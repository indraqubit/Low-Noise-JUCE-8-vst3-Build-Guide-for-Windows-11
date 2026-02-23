# LSP Error Handling in AI Code Editors: OpenCode vs. Cursor, Claude Code

## Executive Summary

Most AI code editors (Cursor, Claude Code) display raw LSP (Language Server Protocol) diagnostics without distinguishing between **parser errors** (false positives) and **actual code errors**. This creates a significant UX problem: LLMs receive noise-filled error lists and attempt to "fix" problems that don't exist, introducing bugs instead of solving them.

**OpenCode** solves this by explicitly categorizing errors and filtering noise before sending diagnostics to the LLM. Other tools leave error filtering as a manual user responsibility.

---

## The Problem: Parser Errors vs. Real Code Errors

### What Are Parser Errors?

Parser errors are false positives reported by language servers when:
- The indexer is incomplete (e.g., C++ standard library not fully indexed)
- Project configuration is complex (JUCE, C++17, custom build systems)
- Includes files are missing from LSP context
- Macro expansions confuse the parser

**Example (C++17/JUCE 8):**
```cpp
#include <vector>
int main() {
    std::vector<int> v;  // clangd says "std not found" (parser error)
    return 0;            // Code actually compiles fine (no real error)
}
```

### What Are Real Code Errors?

Real code errors are actual violations detected by type checkers:
- Type mismatches
- Missing function definitions
- Undefined variables
- Logic errors caught by the compiler

---

## How OpenCode Handles This

### 1. Diagnostic Filtering
- **Only reports severity 1 (ERROR)** diagnostics, ignores warnings/hints
- **Limits output** to first 20 errors per file (tool level) or 3 errors (UI level)
- **Debounces** 150ms to wait for follow-up diagnostics

### 2. Error Source Tracking
OpenCode distinguishes between:
- **LSP Diagnostics**: External language server reports (type checking, linting)
- **Parser Errors**: Internal validation failures (`PatchParseError`, `ShellParseError`)
- **Tool Errors**: Build/compilation errors from actual compilers

### 3. Explicit LLM Feedback
After writing code, OpenCode sends:
```xml
<diagnostics>
  ERROR: Type 'number' is not assignable to type 'string'
  [This is from TypeScript LSP, fix this]
</diagnostics>
```

The LLM knows:
- Error source (LSP, not the tool)
- Error severity
- Whether it's actually blocking or just a parser issue

### 4. Context Management
- Aggregates diagnostics from multiple LSP clients
- Normalizes file paths across OS
- Provides concise summaries to LLM

**Key Files:**
- `packages/opencode/src/lsp/index.ts` - Diagnostic aggregation & filtering
- `packages/opencode/src/lsp/client.ts` - LSP notification handling & debouncing
- `packages/opencode/src/tool/write.ts` - Error filtering in write operations

---

## What Other Tools Are Missing

### Cursor
- Shows all LSP diagnostics without categorization
- No distinction between parser errors and real errors
- User must manually interpret what's real vs. false positive
- Codebase indexing via RAG, but no error source tracking

### Claude Code
- Provides real-time LSP diagnostics (newer feature)
- **But**: Just displays errors as-is, no filtering
- Users report having to manually tell Claude "ignore this parser error"
- No built-in mechanism to distinguish error types

### Community Response
Users are building workarounds:
- `cli-lsp-client` tool on npm - bridges gap by filtering diagnostics before Claude Code sees them
- Reddit discussions - users asking how to prevent Claude from "fixing" false positives
- Forum posts - users struggling with error context management

---

## Effects on Users Not Using OpenCode

### 1. LLM Makes Unnecessary Fixes
```
User → Cursor: "Build my project"
Cursor → Claude: Here are 10 LSP errors
Claude → Tries to fix all 10
Reality: Only 2 are real, 8 are parser noise
Result: Introduces 8 new bugs while "fixing" non-issues
```

### 2. Token Budget Waste
- Sending parser errors to LLM = wasted tokens
- Large error lists consume context window
- Less room for actual code context

### 3. Slower Development Loop
- Fix fake error → introduces bug
- Bug shows up in testing → confuse user
- Another round of debugging needed
- Multiple iterations for single change

### 4. False Error Confidence
User sees 10 errors in IDE, assumes project is broken. Actually:
- 2 real errors (blocking)
- 5 parser false positives (C++/LSP issue)
- 3 linter warnings (non-blocking)

### 5. Bad Code Quality Decisions
LLM prioritizes fixing LSP-reported "errors" first, potentially:
- Ignoring actual logic bugs
- Refactoring code unnecessarily
- Making code worse to satisfy a false diagnostic

### 6. Context Pollution
Raw LSP output in LLM prompt:
```
ERROR: Unknown template argument 'std::optional' (parser)
ERROR: Undefined symbol 'vector' (parser)
ERROR: Type mismatch in line 45 (REAL)
ERROR: Missing include (parser)
```

LLM spends reasoning on 3 false issues, less focus on 1 real issue.

### 7. Debugging Headaches
User: "I only changed variable type, why does it not compile now?"
Reality: Claude "fixed" a parser error that wasn't actually broken, broke the build.

---

## Real-World Scenario: C++17/JUCE 8 Project

### With OpenCode
```
1. User writes JUCE code
2. clangd reports: "std::optional not found" (parser error)
3. OpenCode recognizes this as LSP noise
4. OpenCode tells LLM: "This is parser error, ignore"
5. LLM focuses on actual issues
6. Development proceeds smoothly
```

### Without OpenCode (Cursor/Claude Code)
```
1. User writes JUCE code
2. clangd reports: "std::optional not found"
3. User sees error in sidebar
4. Pastes into Cursor
5. LLM tries to fix: "Include <optional> header"
6. Change breaks actual code (it's already included via JUCE)
7. User spends 30 mins debugging why it broke
8. Eventually realizes it was a parser false positive
```

---

## Best Practices for Non-OpenCode Users

If you're using Cursor, Claude Code, or other AI editors:

### 1. Filter Errors Before Asking LLM
```
❌ Don't: Copy entire error list from LSP
✅ Do: Run actual compiler/build tool
   Only report errors that fail the build
```

### 2. Close LSP Tab
Don't let LLM see the LSP diagnostic panel. Use actual compiler output instead.

### 3. Categorize Errors Manually
```
Real errors (send to LLM):
- Build failures
- Runtime errors
- Test failures

Parser noise (skip):
- clangd confusion about includes
- LSP indexing issues
- Unresolved symbols in template code
```

### 4. Test Before Asking
Compile locally first. If it builds fine, don't report LSP errors to LLM.

### 5. Use Build Output, Not LSP
```
✅ Good: "When I run `cargo build`, I get this error..."
❌ Bad: "Here are all the LSP errors from rust-analyzer..."
```

### 6. Be Explicit with LLM
```
"I see an LSP warning about this, but the code compiles fine.
This might be a false positive. Can you help me understand
if it's actually a problem or if it's safe to ignore?"
```

### 7. Document Parser Errors
For complex projects (C++, JUCE), maintain a "known false positives" list:
```
Known LSP Parser Errors (safe to ignore):
- std::optional not found (clangd indexing issue)
- JUCE_COMEXPORT undefined (macro issue)
- Private member access warnings (JUCE internals)
```

---

## Why OpenCode Built This

OpenCode was designed **LLM-first**, not human-first. Humans can visually scan error lists and intuitively know "that's a parser issue." LLMs can't. They need:

1. **Explicit error categorization** - "This is from LSP, this is from compiler"
2. **Context filtering** - Only relevant errors, no noise
3. **Severity distinction** - "This blocks the build" vs. "This is a warning"
4. **Feedback loops** - "Fix this error" → receives feedback → understands what worked

Other tools retrofitted LSP support into existing editor architectures. They don't have this built-in intelligence.

---

## Comparison Table

| Feature | OpenCode | Cursor | Claude Code |
|---------|----------|--------|------------|
| LSP Support | ✅ Built-in | ✅ Yes | ✅ Recent |
| Error Filtering | ✅ Automatic | ❌ No | ❌ No |
| Parser Error Detection | ✅ Yes | ❌ No | ❌ No |
| Error Categorization | ✅ Yes | ❌ No | ❌ No |
| Severity Mapping | ✅ Yes | ❌ No | ❌ No |
| Diagnostic Debouncing | ✅ 150ms | ❌ No | ❌ No |
| LLM-Aware Feedback | ✅ Yes | ❌ No | ❌ No |
| Manual Error Filtering Required | ❌ No | ✅ Yes | ✅ Yes |

---

## Conclusion

**OpenCode's advantage**: It understands that LLMs need clean, categorized error information to make good decisions. Parser errors confuse LLMs, leading to unnecessary changes and bugs.

**The gap**: Most users don't realize they should filter errors before asking AI. Cursor and Claude Code don't make this distinction, so users suffer through slower, noisier development cycles.

**The opportunity**: For tools building LLM workflows, error intelligence should be a first-class feature, not an afterthought.

---

## References

- OpenCode LSP Implementation: `packages/opencode/src/lsp/`
- Claude Code LSP Support: Medium article "How Claude Code's New LSP Support Changes..."
- Community Tool: `cli-lsp-client` (npm) - User-built workaround for Claude Code
- Cursor Forum: Discussions on context optimization
- Reddit: r/ClaudeCode - Users struggling with false positive handling

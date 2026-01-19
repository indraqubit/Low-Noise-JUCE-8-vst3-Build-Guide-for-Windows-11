# Contributing to JUCE8_VST3_BUILD_GUIDE_WIN_11

Thank you for your interest in contributing! This document outlines the process for contributing to this project.

## Ways to Contribute

- **Report Issues** - Found a bug or have a suggestion?
- **Improve Documentation** - Fix typos, add examples, clarify instructions
- **Add Scripts** - New build scripts, automation tools
- **Share Knowledge** - Tips, tricks, best practices

## Getting Started

### Prerequisites

- Git
- Access to Windows 11 environment
- Familiarity with JUCE and VST3 development

### Setting Up

1. Fork this repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/JUCE8_VST3_BUILD_GUIDE_WIN_11.git
   ```
3. Create a branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. Make your changes
5. Test your changes
6. Commit:
   ```bash
   git commit -m "Add: brief description of changes"
   ```
7. Push and create a PR

## Contribution Guidelines

### Documentation

- Use clear, concise language
- Include code examples where appropriate
- Test all instructions before submitting
- Use Markdown formatting consistently
- Add comments for complex configurations

### Scripts

- Test on clean Windows installation
- Add error handling
- Include comments
- Follow existing code style
- Make scripts idempotent when possible

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

Examples:
```
feat(build): add PowerShell build script
fix(install): resolve SDK path issue
docs(troubleshooting): add common errors
```

## Style Guide

### Markdown

- Use ATX-style headings (# for H1, ## for H2, etc.)
- Limit line length to 80 characters
- Use code blocks for commands and code
- Include blank lines between sections

### Scripts

- Use consistent indentation (4 spaces)
- Add descriptive comments
- Use descriptive variable names
- Handle errors gracefully

## Testing

Before submitting:

1. **Documentation:**
   - [ ] All links work
   - [ ] Commands can be copy-pasted
   - [ ] Screenshots are current

2. **Scripts:**
   - [ ] Tested on clean Windows install
   - [ ] Error messages are helpful
   - [ ] Works with default settings

3. **Code:**
   - [ ] Follows project style
   - [ ] No hardcoded paths (use variables)
   - [ ] Compatible with target environment

## Reporting Issues

When reporting issues, include:

- **Environment:** Windows version, WSL distro, JUCE version
- **Steps to Reproduce:** Clear, numbered steps
- **Expected Behavior:** What should happen
- **Actual Behavior:** What actually happened
- **Error Messages:** Full error text
- **Screenshots:** If applicable

## Questions?

- Check existing [Issues](../../issues)
- Check [Documentation](JUCE8_VST3_BUILD_GUIDE.md)
- Open a new issue for questions

## Recognition

Contributors will be listed in [README.md](README.md) and [CHANGELOG.md](CHANGELOG.md).

---

**By contributing, you agree to follow this code of conduct and the license terms.**

Here are **real-world, production-level JUCE rules** used in commercial plugins & apps.

No fluff — just battle-tested practices.

---

# 💎 LIFETIME & OWNERSHIP RULES

### 1️⃣ Never let a LookAndFeel outlive its Components

```cpp
class MyComp : public juce::Component
{
private:
    MyLookAndFeel lnf;   // FIRST
    juce::Slider slider; // AFTER
};
```

Always:

```cpp
~MyComp() override
{
    slider.setLookAndFeel(nullptr);
}
```

---

### 2️⃣ Never allocate Components with raw `new`

Wrong:

```cpp
addAndMakeVisible(new juce::Slider());
```

Correct:

```cpp
juce::Slider slider;
addAndMakeVisible(slider);
```

Only use `std::unique_ptr` if:

* Component is optional
* Component lifetime is dynamic
* Stored in containers

---

### 3️⃣ No UI allocations in `paint()`

❌ Never:

* allocate
* load images
* create fonts repeatedly
* create Paths every frame unnecessarily

Pre-create heavy objects as members.

---

### 4️⃣ No locking in audio thread. Ever.

Inside:

* `processBlock`
* `prepareToPlay`

❌ No:

* `std::mutex`
* `MessageManagerLock`
* heap allocation
* file IO
* logging
* std::cout

If you need communication → use:

```cpp
std::atomic<float>
juce::AudioProcessorValueTreeState
juce::AbstractFifo
```

---

# 🎛 AUDIO PROCESSOR RULES

### 5️⃣ All parameters must use APVTS (modern JUCE)

Never roll your own parameter system anymore.

```cpp
juce::AudioProcessorValueTreeState apvts;
```

Use attachments:

```cpp
SliderAttachment
ButtonAttachment
ComboBoxAttachment
```

---

### 6️⃣ Never read GUI values in processBlock

Wrong:

```cpp
auto value = slider.getValue();
```

Correct:

```cpp
*apvts.getRawParameterValue("gain")
```

---

### 7️⃣ Denormal protection always

Add in processor constructor:

```cpp
juce::ScopedNoDenormals noDenormals;
```

Or enable flush-to-zero in DSP modules.

---

# 🖥 GUI PERFORMANCE RULES

### 8️⃣ Prefer `setBufferedToImage(true)` for complex static components

Great for:

* Background panels
* Complex vector art
* Knobs with heavy gradients

---

### 9️⃣ Use `repaint(Rectangle)` not full repaint()

Bad:

```cpp
repaint();
```

Better:

```cpp
repaint(knobBounds);
```

---

### 🔟 Avoid `Timer` for animations (prefer `juce::Animator` or `HighResolutionTimer`)

Timers are 60Hz max and jittery.

---

# 🧠 ARCHITECTURE RULES

### 11️⃣ Separate DSP from UI completely

Never put DSP code inside:

* Editor
* Component
* LookAndFeel

DSP lives only in:

```cpp
AudioProcessor
DSP classes
```

---

### 12️⃣ No business logic inside paint()

`paint()` draws.
Nothing else.

---

### 13️⃣ Use `resized()` only for layout

Never compute audio values there.

---

### 14️⃣ Use `JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR`

In every component class.

```cpp
JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(MyComponent)
```

This catches 90% of lifetime bugs.

---

# 🔥 PLUGIN STABILITY RULES

### 15️⃣ Always null attachments before destroying widgets

Order:

```cpp
std::unique_ptr<SliderAttachment> attachment;
juce::Slider slider;
```

Destructor:

```cpp
attachment.reset();
```

Then slider dies safely.

---

### 16️⃣ Never assume host calls in order

Hosts may:

* call `prepareToPlay` multiple times
* call `releaseResources` unpredictably
* change sample rate mid-session

Always handle reinitialisation safely.

---

### 17️⃣ Guard against zero sample rate

```cpp
jassert(sampleRate > 0);
```

---

# 🎨 LOOKANDFEEL PRO RULES

### 18️⃣ Never create a LookAndFeel per widget

Bad:

```cpp
slider.setLookAndFeel(new MyLNF());
```

Good:

```cpp
sharedLnf.set...
```

---

### 19️⃣ Avoid global static LookAndFeel

Causes shutdown crashes in plugins.

---

### 20️⃣ Override only what you use

Don’t subclass entire LookAndFeel unless necessary.

---

# 🧵 THREAD SAFETY RULES

### 21️⃣ UI updates must use Message Thread

From audio thread:

```cpp
juce::MessageManager::callAsync(...)
```

Never touch UI directly.

---

### 22️⃣ Use `AsyncUpdater` instead of locks

Cleaner pattern:

```cpp
class MyComp : public juce::Component,
               private juce::AsyncUpdater
```

---

# 🚀 PERFORMANCE MICRO-OPTIMISATION RULES

### 23️⃣ Prefer stack over heap

### 24️⃣ Prefer `float` over `double` in DSP (unless needed)

### 25️⃣ Precompute trig tables for heavy modulation

---

# 🏆 PROFESSIONAL RELEASE CHECKLIST

Before shipping:

✔ No asserts firing
✔ No MessageManagerLock in audio thread
✔ No memory leaks
✔ No uninitialised parameters
✔ No UI allocations in paint
✔ All attachments owned properly
✔ Plugin validated with PluginDoctor / auval / VST3 validator

---

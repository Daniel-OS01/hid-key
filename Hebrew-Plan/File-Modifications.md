# Required Modifications to Existing Library Files

## File 1: Keyboard.h

### Location
Find the section with keyboard layout declarations (around line 100-110).

### Current Code
```cpp
// Supported keyboard layouts
extern const uint8_t KeyboardLayout_de_DE[];
extern const uint8_t KeyboardLayout_en_US[];
extern const uint8_t KeyboardLayout_es_ES[];
extern const uint8_t KeyboardLayout_fr_FR[];
extern const uint8_t KeyboardLayout_it_IT[];
extern const uint8_t KeyboardLayout_pt_PT[];
extern const uint8_t KeyboardLayout_sv_SE[];
extern const uint8_t KeyboardLayout_da_DK[];
extern const uint8_t KeyboardLayout_hu_HU[];
```

### Add This Line
```cpp
extern const uint8_t KeyboardLayout_he_HE[];
```

### Modified Code (Full Section)
```cpp
// Supported keyboard layouts
extern const uint8_t KeyboardLayout_de_DE[];
extern const uint8_t KeyboardLayout_en_US[];
extern const uint8_t KeyboardLayout_es_ES[];
extern const uint8_t KeyboardLayout_fr_FR[];
extern const uint8_t KeyboardLayout_it_IT[];
extern const uint8_t KeyboardLayout_pt_PT[];
extern const uint8_t KeyboardLayout_sv_SE[];
extern const uint8_t KeyboardLayout_da_DK[];
extern const uint8_t KeyboardLayout_hu_HU[];
extern const uint8_t KeyboardLayout_he_HE[];  // NEW: Hebrew (Israel) layout
```

### Notes
- **Single line addition**
- **No logic changes**
- **No API breaking changes**
- **Alphabetical ordering**: Maintains consistency (he_HE follows hu_HU)

---

## File 2: Keyboard.cpp

### Status: ✓ NO CHANGES REQUIRED

The implementation already uses generic pointer-based layout handling:

```cpp
void Keyboard_::begin(const uint8_t *layout) {
    _asciimap = layout;  // Works with any layout including he_HE
}

size_t Keyboard_::press(uint8_t k) {
    // ...
    k = pgm_read_byte(_asciimap + k);  // Generic lookup for any layout
    // ...
}
```

The keyboard core functions automatically work with the new layout without modifications.

---

## File 3: KeyboardLayout.h

### Location
End of file, in the "== Creating your own layout ==" documentation section.

### Current Code (End of File)
```cpp
#define SHIFT 0x80
#define ALT_GR 0xc0
#define ISO_KEY 0x64
#define ISO_REPLACEMENT 0x32
```

### Add This Documentation Block

After the existing documentation, add:

```cpp

/*
 * == Hebrew Keyboard Layout Special Implementation Notes ==
 * 
 * The Hebrew keyboard layout (SI-1452) for Israeli keyboards presents
 * unique challenges due to the mismatch between ASCII character encoding
 * and Hebrew Unicode encoding.
 * 
 * Challenge: Character Range Limitation
 * -----------------------------------
 * - This library maps ASCII characters (0x00-0x7F) to USB HID scan codes
 * - Hebrew Unicode characters are in range U+0590-U+05FF (outside ASCII)
 * - Direct mapping of Hebrew letters to this 128-entry ASCII table is
 *   impossible with the current library design
 * 
 * Solution: Bilingual Keyboard Approach
 * ------------------------------------
 * 1. Punctuation and Symbols: Map to their Hebrew keyboard positions
 * 2. Latin Letters (a-z): Keep standard ASCII mappings
 * 3. Host OS Integration: Hebrew letters appear when:
 *    - User has Hebrew layout enabled on their OS
 *    - Latin letter keys (a-z) produce Hebrew letters automatically
 * 
 * Implementation Details:
 * ----------------------
 * KeyboardLayout_he_HE.cpp includes:
 * - Standard control characters (Backspace, Tab, Enter, etc.)
 * - Punctuation mapped to SI-1452 Hebrew keyboard positions
 * - Numbers (0-9) with standard keyboard positions
 * - Latin uppercase (A-Z) with SHIFT modifier
 * - Latin lowercase (a-z) without modifier
 * - Unsupported characters (^, `, ~) mapped to 0x00
 * 
 * Special Features:
 * ----------------
 * - ALT_GR modifier used for extended characters (brackets, @, |, etc.)
 * - Parentheses follow logical representation (matches SI-1452 standard)
 * - BiDi (bidirectional) text handling by host OS
 * 
 * Future Enhancement:
 * -------------------
 * A more comprehensive approach would implement a UTF-8 codec layer,
 * similar to the NicoHood/HID library:
 * - Convert UTF-8 input to Unicode
 * - Map Unicode to keyboard layouts
 * - Support combining diacritical marks (niqqud)
 * - Enable direct Hebrew character input without OS layout switching
 * 
 * See: https://github.com/NicoHood/HID for reference implementation
 */
```

### Complete End of File
```cpp
#define SHIFT 0x80
#define ALT_GR 0xc0
#define ISO_KEY 0x64
#define ISO_REPLACEMENT 0x32

/*
 * == Hebrew Keyboard Layout Special Implementation Notes ==
 * 
 * [Documentation block as shown above]
 */
```

### Notes
- **Purely informational**: No code changes
- **Helps future maintainers**: Explains design decisions
- **Supports localization**: Helpful for other bidirectional languages (Arabic, etc.)

---

## Summary of Changes

| File | Type | Action | Impact |
|------|------|--------|--------|
| **Keyboard.h** | Header | Add 1 line | Minimal, declarative only |
| **Keyboard.cpp** | Source | None | Zero impact |
| **KeyboardLayout.h** | Header | Add documentation | Zero impact on function |
| **KeyboardLayout_he_HE.cpp** | NEW | Create | 128-entry layout array |
| **Keyboard_he_HE.h** | NEW | Create | Public layout declaration |

---

## Integration Steps

### Step 1: Copy New Files to Library
1. Copy `KeyboardLayout_he_HE.cpp` to the library source directory
2. Copy `Keyboard_he_HE.h` to the library header directory

### Step 2: Modify Keyboard.h
- Add the single line declaration for `KeyboardLayout_he_HE[]`

### Step 3: Modify KeyboardLayout.h (Optional)
- Add documentation note for future reference

### Step 4: No Changes to Keyboard.cpp
- Verify no modifications needed

### Step 5: Testing
- Compile library without errors
- Verify array sizes are correct
- Test with example sketch

---

## Compilation Verification

After making changes, verify:

```cpp
// Should compile without errors:
#include <Keyboard.h>
#include <Keyboard_he_HE.h>

void setup() {
  Keyboard.begin(KeyboardLayout_he_HE);  // ✓ Should work
}
```

---

## Breaking Change Analysis

✅ **ZERO Breaking Changes**

- Existing sketches continue to work unchanged
- Default layout (en_US) remains unaffected
- API is 100% backward compatible
- Only additive changes (new files, one declaration line)

---

## Version Bump Recommendation

If this were a library version update:
- **Current Version**: 1.0.6
- **Recommended New Version**: 1.0.7 (patch/minor bump)
  - Reason: New feature (new language layout) added, no breaking changes

---

## File Dependencies

```
KeyboardLayout_he_HE.cpp
    ↓
    includes "KeyboardLayout.h"

Keyboard_he_HE.h
    ↓
    declares KeyboardLayout_he_HE (from .cpp)
    
User sketch
    ↓
    #include <Keyboard.h>
    #include <Keyboard_he_HE.h>
    ↓
    uses Keyboard.begin(KeyboardLayout_he_HE)
```

---

## Compilation Output Expected

When compiling with the new files:

```
Compiling sketch...
  Using library Keyboard
  Using library HID
  KeyboardLayout_he_HE.cpp compiled
  Keyboard_he_HE.h included
  Sketch compilation complete
  Memory usage: [similar to other layouts]
```

No warnings or errors expected.

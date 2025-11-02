# Comprehensive Plan: Adding Hebrew Language Support to Arduino Keyboard Library

## Overview
This document outlines the complete strategy for adding Hebrew (he_HE) keyboard layout support to the Arduino Keyboard library, following the SI-1452 standard used in Israel.

---

## 1. Technical Foundation

### 1.1 Library Architecture Understanding

The current library structure uses:
- **Keyboard.h** - Main header with public API and layout declarations
- **Keyboard.cpp** - Core implementation with HID report handling
- **KeyboardLayout.h** - Layout constants (SHIFT=0x80, ALT_GR=0xc0) and documentation
- **KeyboardLayout_xx_YY.cpp** - Language-specific layout arrays (128 elements for ASCII 0-127)

### 1.2 Character Mapping System

The library maps ASCII characters (0-127) to USB HID scan codes with optional modifiers:
- **Plain character**: Direct HID scan code (0x04-0x7F)
- **With SHIFT**: Scan code | 0x80
- **With ALT_GR**: Scan code | 0xC0
- **Unsupported**: 0x00 (results in write error)

### 1.3 Hebrew Keyboard Standard (SI-1452)

Key considerations:
- Standard Hebrew keyboards use 101/104-key layout (ISO/ANSI compatible)
- Built from Hebrew typewriter key order
- **Critical**: Paired delimiters (parentheses, brackets, etc.) use logical representation
  - Shift-9 always produces logical "open parenthesis" (U+0028 or U+0029 depending on direction)
- Right-to-left language with special handling for punctuation
- Bilingual keyboards combine US QWERTY with Hebrew letters

---

## 2. File Creation: KeyboardLayout_he_HE.cpp

### 2.1 Structure Template

```cpp
/*
 * Hebrew keyboard layout (he_HE)
 * Based on SI-1452 standard used in Israel
 * Bilingual: Hebrew letters with US-QWERTY compatible punctuation
 */

#include "KeyboardLayout.h"

extern const uint8_t KeyboardLayout_he_HE[128] PROGMEM = {
  // [128 entries following ASCII order 0-127]
};
```

### 2.2 ASCII Mapping Table Layout

The array maps ASCII characters to Hebrew keyboard scan codes:

**Indices 0-31**: Control characters (mostly 0x00, special handling for TAB, Enter, Backspace)
- 0x00-0x07: Control (0x00)
- 0x08 (BS): 0x2a
- 0x09 (TAB): 0x2b
- 0x0a (LF): 0x28
- 0x0b-0x1f: Control (0x00)

**Indices 32-126**: Printable ASCII characters
- 0x20 (space): 0x2c
- 0x21-0x7e: Punctuation, numbers, Latin letters
- 0x7f (DEL): 0x00

### 2.3 Hebrew Key Position Mapping

Standard Israeli keyboard layout (matching US key positions):

```
Row 1 (numbers): '/' ']' '[' '{' '}' '|' '\\' '@' '#' '$' '%'
Row 2: Tel/סלט Vav/י Mem/מ Nun/נ Het/ח Zayin/ז Yod/י Tet/ט Alef/א
Row 3: Kaf/כ Lamed/ל Final-Mem/ם Nun/נ Gimel/ג Dalet/ד He/ה Yod/י
Row 4: Shift-row (Samekh/ס Final-Tsadi/ץ Pe/פ Final-Pe/ף Tsadi/צ Qof/ק Resh/ר Ayin/ע
```

**Key Implementation Detail**: Hebrew characters are outside the 7-bit ASCII range (0x00-0x7F), so they **cannot be directly mapped** in the 128-entry ASCII table. Instead, the layout must:
1. Map punctuation/symbols to their Hebrew keyboard positions
2. Map modifier combinations (Shift + key)
3. Leave character positions 0x00 for unmappable Hebrew letters (will require separate handling)

### 2.4 Practical Implementation Strategy

Since Hebrew letters (Unicode U+05D0-U+05EA) exceed 8-bit ASCII, the library in its current form has a **fundamental limitation**:
- The keyboard library uses ASCII-to-HID mapping (0-127 range)
- Hebrew Unicode range is 0x0590-0x05FF
- Direct ASCII→Hebrew mapping is impossible

**Solution for Hebrew Support**:
1. **Punctuation/Symbols**: Map to Hebrew keyboard positions
2. **Latin Letters (a-z, A-Z)**: Keep Latin mappings (these switch keyboard layout on host side)
3. **Hebrew Letters**: Document that direct character typing isn't supported; recommend:
   - Using Unicode input methods (Alt codes, Compose keys)
   - Hardware-level keyboard layout switching
   - Extended library modifications for UTF-8/Unicode support

---

## 3. Header File Creation: Keyboard_he_HE.h

**File**: `Keyboard_he_HE.h`

This is a **public header** for user convenience, exposing the layout constant:

```cpp
/*
 * Keyboard_he_HE.h
 * 
 * Hebrew keyboard layout declaration
 * Use with: Keyboard.begin(KeyboardLayout_he_HE);
 */

#ifndef KEYBOARD_HE_HE_H
#define KEYBOARD_HE_HE_H

#include <stdint.h>

/*
 * Hebrew (Israel) keyboard layout based on SI-1452 standard.
 * Includes Hebrew letters with QWERTY-compatible punctuation.
 * 
 * IMPORTANT LIMITATION:
 * - Direct Hebrew Unicode characters (U+05D0-U+05EA) cannot be sent
 *   via the ASCII-based mapping in the current library
 * - Use for punctuation, numbers, and Latin letters
 * - For Hebrew letter input, use host OS keyboard layout switching
 */
extern const uint8_t KeyboardLayout_he_HE[];

#endif // KEYBOARD_HE_HE_H
```

---

## 4. Modifications to Core Files

### 4.1 Keyboard.h - Add Layout Declaration

**Location**: After the existing layout declarations (line ~102-110)

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
extern const uint8_t KeyboardLayout_he_HE[];  // ADD THIS LINE
```

**Impact**: Minimal, single line addition
- No API changes
- No logic modifications
- Purely declarative (matches existing pattern)

### 4.2 Keyboard.cpp - No Changes Required

The implementation uses the generic `_asciimap` pointer:

```cpp
void Keyboard_::begin(const uint8_t *layout) {
    _asciimap = layout;  // Works with any layout including he_HE
}
```

The `press()` and `release()` methods use generic lookup:

```cpp
k = pgm_read_byte(_asciimap + k);  // Works for any layout
```

**Result**: No modifications needed to Keyboard.cpp

### 4.3 KeyboardLayout.h - Add Commentary

**Location**: End of file, in "== Creating your own layout ==" section

Add Hebrew-specific notes:

```cpp
/*
 * == Hebrew Layout Special Considerations ==
 * 
 * The Hebrew keyboard layout (SI-1452) presents unique challenges:
 * 
 * 1. Character Range Limitation:
 *    - ASCII range is 0-127 (7-bit), covers only Latin + control chars
 *    - Hebrew Unicode is U+0590-U+05FF (16-bit), far outside ASCII range
 *    - Current library design cannot map Hebrew Unicode in the 128-entry table
 * 
 * 2. Bilingual Keyboard Approach:
 *    - Hebrew keyboards include both Latin and Hebrew layouts
 *    - This library maps the punctuation/symbol layer
 *    - Letters (a-z) remain as Latin (host handles layout switching)
 * 
 * 3. Delimiter Note:
 *    - Shift-9 produces logical "open parenthesis" (not physical position)
 *    - Implementation maps to 0x25|SHIFT matching logical representation
 *    - Host OS will render according to RTL text direction
 * 
 * 4. Future Enhancement:
 *    - Consider UTF-8 codec layer for proper Unicode support
 *    - Would require significant library refactoring
 *    - See: https://github.com/NicoHood/HID for Unicode approach
 */
```

---

## 5. Implementation Workflow

### Phase 1: Create Base Files
1. ✅ Create `KeyboardLayout_he_HE.cpp` with 128-entry array
   - Map control characters (indices 0-31)
   - Map punctuation/symbols/numbers (indices 32-126)
   - Map Latin letters to their keyboard positions
   - Document unsupported characters with 0x00

2. ✅ Create `Keyboard_he_HE.h` as public header
   - Add usage documentation
   - Include limitation notices
   - Example usage comment

3. ✅ Update `Keyboard.h`
   - Add `extern const uint8_t KeyboardLayout_he_HE[];` declaration

### Phase 2: Integration Testing
1. Compile check (no syntax errors)
2. Verify array size (exactly 128 elements)
3. Check PROGMEM storage (array placed in program memory)
4. Test on Pro Micro with Hebrew OS keyboard layout enabled

### Phase 3: Documentation
1. Add example sketch: `examples/HelloWorld_Hebrew.ino`
2. Update library README with Hebrew language note
3. Document workaround for Hebrew letter input
4. Add troubleshooting guide

---

## 6. Technical Specifications for KeyboardLayout_he_HE.cpp

### 6.1 Key-to-Scancode Mappings

Based on standard Israeli keyboard layout:

| ASCII | Char | Key Position | Scancode | Modifiers |
|-------|------|--------------|----------|-----------|
| 0x20  | ' '  | Space        | 0x2c     | -         |
| 0x21  | '!'  | Shift-1      | 0x1e     | SHIFT     |
| 0x22  | '"'  | Shift-2      | 0x1f     | SHIFT     |
| 0x23  | '#'  | Shift-3      | 0x20     | ALT_GR    |
| 0x24  | '$'  | Shift-4      | 0x21     | SHIFT     |
| 0x25  | '%'  | Shift-5      | 0x22     | SHIFT     |
| 0x26  | '&'  | Shift-6      | 0x23     | SHIFT     |
| 0x27  | '''  | Shift-7      | 0x2d     | -         |
| 0x28  | '('  | Shift-8      | 0x25     | SHIFT     |
| 0x29  | ')'  | Shift-9      | 0x26     | SHIFT     |
| 0x2a  | '*'  | Shift-0      | 0x30     | SHIFT     |
| 0x2b  | '+'  | Shift-+/-    | 0x30     | -         |
| 0x2c  | ','  | ,/</         | 0x36     | -         |
| 0x2d  | '-'  | -/_          | 0x38     | -         |
| 0x2e  | '.'  | ./?>         | 0x37     | -         |
| 0x2f  | '/'  | '/?          | 0x24     | SHIFT     |
| 0x30-0x39 | '0'-'9' | Numbers | 0x27-0x20 | - |
| 0x3a  | ':'  | ;/:          | 0x37     | SHIFT     |
| 0x3b  | ';'  | ;/:          | 0x36     | SHIFT     |
| 0x3c  | '<'  | ,/<          | 0x32     | -         |
| 0x3d  | '='  | =            | 0x27     | SHIFT     |
| 0x3e  | '>'  | ,/>          | 0x32     | SHIFT     |
| 0x3f  | '?'  | '/?          | 0x2d     | SHIFT     |
| 0x40  | '@'  | @            | 0x1f     | ALT_GR    |
| 0x41-0x5a | A-Z | Latin letters | 0x04-0x1d | SHIFT |
| 0x5b  | '['  | [/{          | 0x2f     | ALT_GR    |
| 0x5c  | '\\' | \\|          | 0x35     | ALT_GR    |
| 0x5d  | ']'  | ]/}          | 0x30     | ALT_GR    |
| 0x5e  | '^'  | ^            | 0x00     | - (unsupported) |
| 0x5f  | '_'  | _            | 0x38     | SHIFT     |
| 0x60  | '`'  | `            | 0x00     | - (unsupported) |
| 0x61-0x7a | a-z | Latin letters | 0x04-0x1d | - |
| 0x7b  | '{'  | [{           | 0x34     | ALT_GR    |
| 0x7c  | '\|' | \|           | 0x1e     | ALT_GR    |
| 0x7d  | '}'  | ]}           | 0x31     | ALT_GR    |
| 0x7e  | '~'  | ~            | 0x00     | - (unsupported) |

### 6.2 Scan Code Reference (ISO Layout)

Standard positions for reference:

```
Row 1: 0x35(`) 0x1e(1) 0x1f(2) 0x20(3) 0x21(4) 0x22(5) 0x23(6) 
       0x24(7) 0x25(8) 0x26(9) 0x27(0) 0x2d(-) 0x2e(=) BKSP(0x2a)

Row 2: TAB(0x2b) 0x14 0x1a 0x08 0x15 0x17 0x1c 0x18 0x0c 0x12 0x13 
       0x2f([) 0x30(]) 0x31(\)

Row 3: CAPS(0x39) 0x04 0x16 0x07 0x09 0x0a 0x0b 0x0d 0x0e 0x0f 0x33 0x34 ENTER(0x28)

Row 4: SHIFT(0x02) 0x32 0x1d 0x1b 0x06 0x19 0x05 0x11 0x10 0x36 0x37 SHIFT(0x02)

Row 5: CTRL SUPER ALT SPACE ALT SUPER MENU CTRL
```

---

## 7. Usage Example

After implementation, users can enable Hebrew keyboard layout:

```cpp
#include <Keyboard.h>
#include <Keyboard_he_HE.h>

void setup() {
  Keyboard.begin(KeyboardLayout_he_HE);
}

void loop() {
  // Type "hello"
  Keyboard.print("hello");
  delay(1000);
  
  // Type symbols (will appear in Hebrew keyboard positions)
  Keyboard.print("!@#$%");
  delay(1000);
}
```

---

## 8. Limitations & Future Work

### Current Limitations
1. **Hebrew Letters**: Cannot send directly (require UTF-8 codec)
2. **Combining Marks**: Not supported in 7-bit ASCII range
3. **RTL Logic**: Handled by host OS, not by Arduino

### Future Enhancement Opportunities
1. Implement UTF-8 to HID scancode converter
2. Support combining diacritical marks (niqqud)
3. Add Yiddish-specific layout variant
4. Reference NicoHood/HID library for Unicode approach

---

## 9. Testing Checklist

- [ ] `KeyboardLayout_he_HE.cpp` compiles without errors
- [ ] Array contains exactly 128 uint8_t entries
- [ ] PROGMEM storage verified
- [ ] `Keyboard.h` includes declaration without breaking existing code
- [ ] Sketch compiles with `#include <Keyboard_he_HE.h>`
- [ ] `Keyboard.begin(KeyboardLayout_he_HE);` initializes without errors
- [ ] `Keyboard.print()` functions work correctly
- [ ] Punctuation appears in correct Hebrew keyboard positions
- [ ] Latin letters remain functional
- [ ] Tested on Arduino Pro Micro / Micro board
- [ ] Documentation and examples provided

---

## 10. File Summary

| File | Type | Action | Lines |
|------|------|--------|-------|
| KeyboardLayout_he_HE.cpp | New | Create | ~150 |
| Keyboard_he_HE.h | New | Create | ~25 |
| Keyboard.h | Modify | Add extern declaration | +1 |
| Keyboard.cpp | None | No changes | - |
| KeyboardLayout.h | Modify | Add documentation note | +20 |

**Total Impact**: 
- 2 new files (165 lines)
- 2 modified files (1 + 20 lines)
- 0 breaking changes
- Full backward compatibility maintained

---

## 11. References

- **SI-1452 Standard**: Israeli Hebrew Keyboard Layout
- **USB HID Spec**: Keyboard/Keypad Page (0x07)
- **Arduino Keyboard Library**: Current implementation
- **Unicode Hebrew Block**: U+0590 to U+05FF, U+FB1D to U+FB4F
- **Related Work**: NicoHood/HID library (Unicode approach)

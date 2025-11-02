/*
 * KeyboardLayout_he_HE.cpp
 *
 * Hebrew keyboard layout for Arduino Keyboard library
 * Based on SI-1452 standard (Israeli Hebrew keyboard)
 *
 * Note: This layout maps the punctuation/symbol layer.
 * Direct Hebrew Unicode characters cannot be sent through the
 * ASCII-based keyboard mapping system. For Hebrew letter input,
 * the host OS must have Hebrew keyboard layout enabled, and
 * Latin letter keys (a-z) will produce Hebrew letters when
 * the Hebrew layout is active.
 */

#include "KeyboardLayout.h"

extern const uint8_t KeyboardLayout_he_HE[128] PROGMEM = {
  // 0x00 - 0x07: Control characters (NUL, SOH, STX, ETX, EOT, ENQ, ACK, BEL)
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

  // 0x08 - 0x0F: (BS, TAB, LF/Enter, VT, FF, CR, SO, SI)
  0x2a, // BS    Backspace
  0x2b, // TAB   Tab
  0x28, // LF    Enter
  0x00, // VT    Vertical Tab (unsupported)
  0x00, // FF    Form Feed (unsupported)
  0x00, // CR    Carriage Return (unsupported)
  0x00, // SO    Shift Out (unsupported)
  0x00, // SI    Shift In (unsupported)

  // 0x10 - 0x1F: Control characters
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

  // 0x20: Space
  0x2c,

  // 0x21 - 0x2F: !"#$%&'()*+,-./
  0x1e|SHIFT,    // ! (Shift+1)
  0x34|SHIFT,    // " (on US ' key, shifted)
  0x20|SHIFT,    // # (Shift+3)
  0x21|SHIFT,    // $ (Shift+4)
  0x22|SHIFT,    // % (Shift+5)
  0x23|SHIFT,    // & (Shift+6)
  0x33,          // ' (on US ; key)
  0x27|SHIFT,    // ( (Shift+0)
  0x26|SHIFT,    // ) (Shift+9)
  0x25|SHIFT,    // * (Shift+8)
  0x2e|SHIFT,    // + (on US = key, shifted)
  0x34,          // , (on US ' key)
  0x2d,          // - (on US - key)
  0x38,          // . (on US / key)
  0x37,          // / (on US . key)

  // 0x30 - 0x39: 0-9 (Numbers)
  0x27,          // 0
  0x1e,          // 1
  0x1f,          // 2
  0x20,          // 3
  0x21,          // 4
  0x22,          // 5
  0x23,          // 6
  0x24,          // 7
  0x25,          // 8
  0x26,          // 9

  // 0x3A - 0x40: :;<=>?@
  0x33|SHIFT,    // : (on US ; key, shifted)
  0x1d|SHIFT,    // ; (on US z key, shifted)
  0x36|SHIFT,    // < (on US , key, shifted)
  0x2e,          // = (on US = key)
  0x37|SHIFT,    // > (on US . key, shifted)
  0x38|SHIFT,    // ? (on US / key, shifted)
  0x1f|SHIFT,    // @ (on US 2 key, shifted)

  // 0x41 - 0x5A: A-Z (Latin uppercase letters)
  0x04|SHIFT, // A
  0x05|SHIFT, // B
  0x06|SHIFT, // C
  0x07|SHIFT, // D
  0x08|SHIFT, // E
  0x09|SHIFT, // F
  0x0a|SHIFT, // G
  0x0b|SHIFT, // H
  0x0c|SHIFT, // I
  0x0d|SHIFT, // J
  0x0e|SHIFT, // K
  0x0f|SHIFT, // L
  0x10|SHIFT, // M
  0x11|SHIFT, // N
  0x12|SHIFT, // O
  0x13|SHIFT, // P
  0x14|SHIFT, // Q
  0x15|SHIFT, // R
  0x16|SHIFT, // S
  0x17|SHIFT, // T
  0x18|SHIFT, // U
  0x19|SHIFT, // V
  0x1a|SHIFT, // W
  0x1b|SHIFT, // X
  0x1c|SHIFT, // Y
  0x1d|SHIFT, // Z

  // 0x5B - 0x60: [\]^_`
  0x2f,          // [ (on US [ key)
  0x31,          // \ (on US \ key)
  0x30,          // ] (on US ] key)
  0x23|SHIFT,    // ^ (on US 6 key, shifted)
  0x2d|SHIFT,    // _ (on US - key, shifted)
  0x35,          // ` (on US ` key)

  // 0x61 - 0x7A: a-z (Latin lowercase letters)
  0x04, // a
  0x05, // b
  0x06, // c
  0x07, // d
  0x08, // e
  0x09, // f
  0x0a, // g
  0x0b, // h
  0x0c, // i
  0x0d, // j
  0x0e, // k
  0x0f, // l
  0x10, // m
  0x11, // n
  0x12, // o
  0x13, // p
  0x14, // q
  0x15, // r
  0x16, // s
  0x17, // t
  0x18, // u
  0x19, // v
  0x1a, // w
  0x1b, // x
  0x1c, // y
  0x1d, // z

  // 0x7B - 0x7E: {|}~
  0x2f|SHIFT,    // { (on US [ key, shifted)
  0x31|SHIFT,    // | (on US \ key, shifted)
  0x30|SHIFT,    // } (on US ] key, shifted)
  0x35|SHIFT,    // ~ (on US ` key, shifted)

  // 0x7F: DEL
  0x00
};

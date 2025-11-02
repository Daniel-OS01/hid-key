/*
  Keyboard_he_HE.h
  Constants for the Hebrew keyboard layout.
*/

#ifndef KEYBOARD_HE_HE_h
#define KEYBOARD_HE_HE_h

#include "HID.h"

#if !defined(_USING_HID)

#warning "Using legacy HID core (non pluggable)"

#else

//================================================================================
//================================================================================
//  Keyboard

// he_HE keys
// Based on physical scan codes from KeyboardLayout.h
// Base offset 136

// Top (QWERTY) Row
#define KEY_HE_SLASH        (136+0x14)  // Q
#define KEY_HE_APOSTROPHE   (136+0x1A)  // W (גרש)
#define KEY_HE_QOF          (136+0x08)  // E (ק)
#define KEY_HE_RESH         (136+0x15)  // R (ר)
#define KEY_HE_ALEF         (136+0x17)  // T (א)
#define KEY_HE_TET          (136+0x1C)  // Y (ט)
#define KEY_HE_VAV          (136+0x18)  // U (ו)
#define KEY_HE_FINAL_NUN    (136+0x0C)  // I (ן)
#define KEY_HE_FINAL_MEM    (136+0x12)  // O (ם)
#define KEY_HE_PE           (136+0x13)  // P (פ)

// Middle (ASDF) Row
#define KEY_HE_SHIN         (136+0x04)  // A (ש)
#define KEY_HE_DALET        (136+0x16)  // S (ד)
#define KEY_HE_GIMEL        (136+0x07)  // D (ג)
#define KEY_HE_KAF          (136+0x09)  // F (כ)
#define KEY_HE_AYIN         (136+0x0A)  // G (ע)
#define KEY_HE_YOD          (136+0x0B)  // H (י)
#define KEY_HE_HET          (136+0x0D)  // J (ח)
#define KEY_HE_LAMED        (136+0x0E)  // K (ל)
#define KEY_HE_FINAL_KAF    (136+0x0F)  // L (ך)
#define KEY_HE_FINAL_PE     (136+0x33)  // ; (ף)
#define KEY_HE_COMMA_HEBREW (136+0x34)  // ' (פסיק)

// Bottom (ZXCV) Row
#define KEY_HE_ZAYIN        (136+0x1D)  // Z (ז)
#define KEY_HE_SAMEKH       (136+0x1B)  // X (ס)
#define KEY_HE_BET          (136+0x06)  // C (ב)
#define KEY_HE_HE           (136+0x19)  // V (ה)
#define KEY_HE_NUN          (136+0x05)  // B (נ)
#define KEY_HE_MEM          (136+0x11)  // N (מ)
#define KEY_HE_TSADI        (136+0x10)  // M (צ)
#define KEY_HE_TAV          (136+0x36)  // , (ת)
#define KEY_HE_FINAL_TSADI  (136+0x37)  // . (ץ)
#define KEY_HE_PERIOD       (136+0x38)  // / (נקודה)


#endif
#endif

/*
 * Keyboard_he_HE.h
 * 
 * Hebrew keyboard layout declaration for Arduino Keyboard library
 * Based on SI-1452 standard (Israeli Hebrew keyboard)
 * 
 * Usage:
 *   #include <Keyboard.h>
 *   #include <Keyboard_he_HE.h>
 *   
 *   void setup() {
 *     Keyboard.begin(KeyboardLayout_he_HE);
 *   }
 * 
 * IMPORTANT - Library Limitations:
 * 
 * This library uses ASCII-based character mapping (0-127 range).
 * Hebrew Unicode characters are in range U+0590-U+05FF (far outside ASCII).
 * 
 * Therefore:
 * - Punctuation and symbols will use Hebrew keyboard positions ✓
 * - Latin letters (a-z, A-Z) will work normally ✓
 * - Direct Hebrew character input is NOT supported ✗
 * 
 * For Hebrew letter input:
 * 1. Enable Hebrew keyboard layout on your operating system
 * 2. The Latin letter keys (a-z) will produce Hebrew letters
 *    when the host OS has Hebrew layout active
 * 3. Use Keyboard.write() with Latin characters that correspond
 *    to desired Hebrew letters
 * 
 * Example:
 *   Keyboard.write('a');  // Produces 'alef' (א) on Hebrew layout
 *   Keyboard.write('b');  // Produces 'bet' (ב) on Hebrew layout
 * 
 * For More Information:
 * - SI-1452 Israeli Keyboard Standard
 * - Hebrew Unicode Block: U+0590-U+05FF
 * - Unicode 15.0 Hebrew documentation
 */

#ifndef KEYBOARD_HE_HE_H
#define KEYBOARD_HE_HE_H

#include <stdint.h>

/*
 * Hebrew (Israel / he_HE) keyboard layout
 * 
 * Provides access to the KeyboardLayout_he_HE array which maps
 * ASCII characters to USB HID scan codes for the Israeli Hebrew keyboard.
 * 
 * The layout follows the SI-1452 standard and includes support for
 * punctuation, numbers, and Latin letters. When used with a Hebrew-enabled
 * keyboard layout on the host computer, Latin letters will produce their
 * corresponding Hebrew letters.
 */
extern const uint8_t KeyboardLayout_he_HE[];

#endif // KEYBOARD_HE_HE_H

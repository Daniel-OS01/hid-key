/*
  Hebrew Keyboard Layout Example

  This sketch demonstrates how to use the Hebrew keyboard layout with the
  Arduino Keyboard library.

  To use this sketch:
  1. Upload the code to an Arduino board with USB capabilities (e.g.,
     Arduino Pro Micro, Leonardo, Micro).
  2. Open a text editor on your computer.
  3. Set your computer's keyboard layout to Hebrew.
  4. The sketch will type a test message. Observe how the Latin
     characters in the `Keyboard.print()` command are translated into
     Hebrew letters and symbols according to the SI-1452 standard.

  For more information on the Hebrew keyboard layout implementation, refer
  to the documentation in `Keyboard_he_HE.h`.
*/

#include <Keyboard.h>
#include "Keyboard_he_HE.h"

void setup() {
  // Start the keyboard library, specifying the Hebrew layout.
  Keyboard.begin(KeyboardLayout_he_HE);
}

void loop() {
  // A one-time message to demonstrate the layout.
  // When your OS is set to the Hebrew layout:
  // "hello" will appear as "שמעעם"
  // "123" will appear as "123"
  // "!@#" will appear as "1!#" (Shift+1, AltGr+2, AltGr+3)
  Keyboard.print("hello123!@#");

  // A loop to prevent the message from repeating.
  while(1);
}

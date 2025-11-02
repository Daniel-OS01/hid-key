/*
  Hebrew Letter Mapping Test

  This sketch tests the mapping of lowercase Latin letters (a-z) to their
  corresponding Hebrew characters.

  To use this sketch:
  1. Upload the code to an Arduino board with USB capabilities.
  2. Open a text editor on your computer.
  3. Set your computer's keyboard layout to Hebrew.
  4. The sketch will type the alphabet. Verify that the output matches
     the expected Hebrew phonetic mapping.
*/

#include <Keyboard.h>
#include "Keyboard_he_HE.h"

void setup() {
  // Start the keyboard library, specifying the Hebrew layout.
  Keyboard.begin(KeyboardLayout_he_HE);
}

void loop() {
  // A one-time message to demonstrate the layout.
  Keyboard.println("Testing lowercase letters:");
  Keyboard.println("abcdefghijklmnopqrstuvwxyz");

  // A loop to prevent the message from repeating.
  while(1);
}

/*
  Hebrew Shifted Letter Mapping Test

  This sketch tests the mapping of uppercase Latin letters (A-Z) to their
  corresponding Hebrew characters (or lack thereof, as Hebrew does not have
  case differences).

  To use this sketch:
  1. Upload the code to an Arduino board with USB capabilities.
  2. Open a text editor on your computer.
  3. Set your computer's keyboard layout to Hebrew.
  4. The sketch will type the alphabet in uppercase. Verify the output.
*/

#include <Keyboard.h>
#include "Keyboard_he_HE.h"

void setup() {
  // Start the keyboard library, specifying the Hebrew layout.
  Keyboard.begin(KeyboardLayout_he_HE);
}

void loop() {
  // A one-time message to demonstrate the layout.
  Keyboard.println("Testing uppercase letters:");
  Keyboard.println("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

  // A loop to prevent the message from repeating.
  while(1);
}

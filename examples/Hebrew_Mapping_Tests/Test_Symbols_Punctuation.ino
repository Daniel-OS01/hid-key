/*
  Hebrew Symbol and Punctuation Mapping Test

  This sketch tests the mapping of symbols and punctuation characters.

  To use this sketch:
  1. Upload the code to an Arduino board with USB capabilities.
  2. Open a text editor on your computer.
  3. Set your computer's keyboard layout to Hebrew.
  4. The sketch will type a series of symbols and punctuation. Verify that
     the output matches the SI-1452 standard for the Hebrew keyboard.
*/

#include <Keyboard.h>
#include "Keyboard_he_HE.h"

void setup() {
  // Start the keyboard library, specifying the Hebrew layout.
  Keyboard.begin(KeyboardLayout_he_HE);
}

void loop() {
  // A one-time message to demonstrate the layout.
  Keyboard.println("Testing symbols and punctuation:");
  Keyboard.println("`1234567890-=[]\\;',./");
  Keyboard.println("~!@#$%^&*()_+{}|:\"<>?");

  // A loop to prevent the message from repeating.
  while(1);
}

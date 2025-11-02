/*
  Hebrew Keyboard Layout Test

  This sketch demonstrates how to use the Hebrew keyboard layout with the
  Arduino Keyboard library. It prints a test string to the connected computer.

  To use this sketch:
  1. Upload it to an Arduino board with USB capabilities (e.g., Leonardo, Micro).
  2. Open a text editor on your computer.
  3. Ensure your computer's keyboard layout is set to Hebrew.

  The circuit:
  - No external circuit is needed for this example.

  created 2 Nov 2025
  by Your Name
*/

#include "Keyboard.h"
#include "Keyboard_he_HE.h"

void setup() {
  // Start the keyboard library, specifying the Hebrew layout.
  Keyboard.begin(KeyboardLayout_he_HE);
}

void loop() {
  // A small delay to allow you to open a text editor.
  delay(5000);

  // Print a test string. The characters sent are standard ASCII.
  // The computer's OS will interpret these keystrokes based on the
  // currently selected keyboard layout. If the layout is set to Hebrew,
  // this will produce Hebrew characters.
  Keyboard.println("q w e r t y u i o p"); // Should produce Hebrew letters
  Keyboard.println("a s d f g h j k l ; '");
  Keyboard.println("z x c v b n m , . /");
  Keyboard.println("1234567890-=");
  Keyboard.println("!@#$%^&*()_+");
  Keyboard.println("{[}]|\\");

  // End of the test, do nothing more.
  while (1);
}

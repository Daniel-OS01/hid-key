/*
  Serial to Keyboard

  This sketch listens for incoming data on the serial port and outputs it
  as keystrokes. This allows you to use a script on your computer to send
  text to the Arduino, which will then type it on a host computer.

  To use this sketch:
  1. Upload this code to your Arduino board with USB capabilities (e.g., Pro Micro).
  2. Use a Python or PowerShell script to send text to the Arduino's serial port.
*/

#include <Keyboard.h>

void setup() {
  // Open the serial port and wait for it to be ready.
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // Start the Keyboard library.
  Keyboard.begin();
}

void loop() {
  // Check if there is data available to read from the serial port.
  if (Serial.available() > 0) {
    // Read the incoming byte.
    char inChar = Serial.read();

    // Type the character.
    Keyboard.write(inChar);
  }
}

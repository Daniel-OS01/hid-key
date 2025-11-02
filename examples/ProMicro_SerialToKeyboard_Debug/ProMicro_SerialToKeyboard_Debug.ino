#include "Keyboard.h"

int inCh = 0;

void initSerials() {
  // Enable the hardware serial port for debugging
  Serial.begin(9600);
  while (!Serial);
  Serial.println("Debug Serial ready!");

  // Enable the hardware serial port for receiving characters
  Serial1.begin(9600);
  while (!Serial1);
  Serial1.println("Input Serial1 ready!");
}

void setup() {
  initSerials();
  Keyboard.begin();
}

void loop() {
  if (Serial1.available() > 0) {
    // Read the incoming character
    inCh = Serial1.read();

    // Print debug information to the Serial Monitor
    Serial.print("Received char: '");
    Serial.print((char)inCh);
    Serial.print("' (ASCII: ");
    Serial.print(inCh, DEC);
    Serial.print("), Buffer size: ");
    Serial.print(Serial1.available());

    // Decide which key to send
    switch (inCh) {
      case 13: // Carriage Return
        Serial.println(" -> Sending: KEY_RETURN");
        Keyboard.write(KEY_RETURN);
        break;

      default:
        Serial.print(" -> Sending char: '");
        Serial.print((char)inCh);
        Serial.println("'");
        Keyboard.write((char)inCh);
    }
  }
}

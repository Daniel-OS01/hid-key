# send_clipboard.py
#
# This script reads text from the clipboard and sends it to an Arduino
# running the SerialToKeyboard sketch. This allows you to type Hebrew
# or any other language by sending it to the Arduino.
#
# Dependencies:
#   pip install pyserial pyperclip
#
# Usage:
#   1. Copy the Hebrew text you want to type to your clipboard.
#   2. Run this script: python send_clipboard.py
#   3. The script will find the Arduino and send the text.

import time
import serial
import serial.tools.list_ports
import pyperclip

# --- Configuration ---
BAUD_RATE = 9600
# Delay between each character sent to the Arduino (in seconds).
# Increase this if characters are being missed.
CHARACTER_DELAY = 0.05

def find_arduino_port():
    """
    Scans for and returns the serial port of a connected Arduino.
    """
    ports = serial.tools.list_ports.comports()
    for port in ports:
        # Arduinos often have "Arduino" or "USB-SERIAL" in their description.
        if "Arduino" in port.description or "USB-SERIAL" in port.description:
            return port.device
    return None

def main():
    """
    Main function to find the Arduino, read clipboard text, and send it.
    """
    print("Looking for Arduino...")
    arduino_port = find_arduino_port()

    if not arduino_port:
        print("Error: Could not find a connected Arduino.")
        print("Please ensure your Arduino is connected and the correct drivers are installed.")
        return

    print(f"Found Arduino on port: {arduino_port}")

    # Get text from the clipboard.
    text_to_send = pyperclip.paste()
    if not text_to_send:
        print("Clipboard is empty. Please copy some text and try again.")
        return

    print(f"Sending the following text from clipboard:\n---\n{text_to_send}\n---")

    try:
        with serial.Serial(arduino_port, BAUD_RATE, timeout=1) as ser:
            # Give the Arduino time to initialize after opening the serial connection.
            time.sleep(2)

            # Send the text character by character.
            for char in text_to_send:
                ser.write(char.encode('utf-8'))
                time.sleep(CHARACTER_DELAY)

            print("Text sent successfully.")

    except serial.SerialException as e:
        print(f"Error: Could not open serial port {arduino_port}.")
        print(f"Details: {e}")

if __name__ == "__main__":
    main()

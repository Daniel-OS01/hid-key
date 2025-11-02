import serial
import pyperclip
import time
import argparse

# This mapping is based on the standard Hebrew keyboard layout (SI-1452)
# The key is the Hebrew character, and the value is the corresponding US QWERTY key.
HEBREW_QWERTY_MAP = {
    'א': 't', 'ב': 'c', 'ג': 'd', 'ד': 's', 'ה': 'v', 'ו': 'u',
    'ז': 'z', 'ח': 'j', 'ט': 'y', 'י': 'h', 'כ': 'f', 'ל': 'k',
    'מ': 'n', 'נ': 'b', 'ס': 'x', 'ע': 'g', 'פ': 'p', 'צ': 'm',
    'ק': 'e', 'ר': 'r', 'ש': 'a', 'ת': ',', 'ך': 'l', 'ם': 'o',
    'ן': 'i', 'ף': ';', 'ץ': ',',
    # Shifted characters
    '~': '`', '!': '1', '@': '2', '#': '3', '$': '4', '%': '5',
    '^': '6', '&': '7', '*': '8', '(': '9', ')': '0', '_': '-',
    '+': '=',
    # Punctuation
    ',': '.', '/': 'q', '.': '/', "'": "'", ';': 'w', '\\': '\\',
    '[': ']', ']': '[',
}

def send_text_to_arduino(text, port, baudrate=9600, delay=0.01):
    """
    Sends the given text to the Arduino over the specified serial port.

    Args:
        text (str): The text to send.
        port (str): The serial port to connect to (e.g., 'COM3' or '/dev/ttyACM0').
        baudrate (int): The baud rate of the serial connection.
        delay (float): The delay between sending each character, in seconds.
    """
    try:
        with serial.Serial(port, baudrate, timeout=1) as ser:
            # Wait for the Arduino to reset after establishing the serial connection.
            # This is crucial for boards like the Pro Micro that have native USB.
            time.sleep(2)

            print(f"Connected to {port} at {baudrate} baud.")
            print("Sending text from clipboard...")

            for char in text:
                if char in HEBREW_QWERTY_MAP:
                    qwerty_char = HEBREW_QWERTY_MAP[char]
                    ser.write(qwerty_char.encode('ascii'))
                    print(f"Sent '{qwerty_char}' for Hebrew char '{char}'")
                elif ' ' <= char <= '~':  # Regular ASCII characters
                    ser.write(char.encode('ascii'))
                    print(f"Sent ASCII char '{char}'")
                elif char == '\n':
                    ser.write(b'\r') # Send carriage return for newline
                    print("Sent newline")
                else:
                    print(f"Skipping unsupported character: '{char}'")

                time.sleep(delay)

            print("Done.")
    except serial.SerialException as e:
        print(f"Error: Could not open serial port {port}. Please check the port and permissions.")
        print(e)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send Hebrew text from the clipboard to an Arduino Keyboard.")
    parser.add_argument("port", help="The serial port of the Arduino (e.g., COM3 or /dev/ttyACM0)")
    parser.add_argument("--baud", type=int, default=9600, help="The baud rate for the serial connection (default: 9600)")
    parser.add_argument("--delay", type=float, default=0.02, help="The delay between characters in seconds (default: 0.02)")

    args = parser.parse_args()

    # Get text from the clipboard
    clipboard_text = pyperclip.paste()

    if not clipboard_text:
        print("Clipboard is empty. Please copy some Hebrew text.")
    else:
        send_text_to_arduino(clipboard_text, args.port, args.baud, args.delay)

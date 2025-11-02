:repository-owner: arduino-libraries
:repository-name: Keyboard

= {repository-name} Library for Arduino =

image:https://github.com/{repository-owner}/{repository-name}/actions/workflows/check-arduino.yml/badge.svg["Check Arduino status", link="https://github.com/{repository-owner}/{repository-name}/actions/workflows/check-arduino.yml"]
image:https://github.com/{repository-owner}/{repository-name}/actions/workflows/compile-examples.yml/badge.svg["Compile Examples status", link="https://github.com/{repository-owner}/{repository-name}/actions/workflows/compile-examples.yml"]
image:https://github.com/{repository-owner}/{repository-name}/actions/workflows/spell-check.yml/badge.svg["Spell Check status", link="https://github.com/{repository-owner}/{repository-name}/actions/workflows/spell-check.yml"]

This library allows an Arduino board with USB capabilities to act as a keyboard.

For more information about this library please visit us at
https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/

== License ==

Copyright (c) Arduino LLC. All right reserved.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

---

## Description

The keyboard functions enable 32u4 or SAMD micro based boards to send keystrokes to an attached computer through their micro’s native USB port.

**Note: Not every possible ASCII character, particularly the non-printing ones, can be sent with the Keyboard library.**

The library supports the use of modifier keys. Modifier keys change the behavior of another key when pressed simultaneously. [See here](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardModifiers) for additional information on supported keys and their use.

## Compatible Hardware

HID is supported on the following boards:

| Board | Supported Pins |
| --- | --- |
| [Leonardo](https://docs.arduino.cc/hardware/leonardo) | All digital & analog pins |
| [Micro](https://docs.arduino.cc/hardware/micro) | All digital & analog pins |
| [Due](https://docs.arduino.cc/hardware/due) | All digital & analog pins |
| [Zero](https://docs.arduino.cc/hardware/zero) | All digital & analog pins |
| [UNO R4 Minima](https://docs.arduino.cc/hardware/uno-r4-minima) | All digital & analog pins |
| [UNO R4 WiFi](https://docs.arduino.cc/hardware/uno-r4-wifi) | All digital & analog pins |
| [GIGA R1 WiFi](https://docs.arduino.cc/hardware/giga-r1-wifi) | All digital & analog pins |
| [Nano ESP32](https://docs.arduino.cc/hardware/nano-esp32) | All digital & analog pins |
| [MKR Family](https://docs.arduino.cc/#mkr-family) | All digital & analog pins |

## Notes and Warnings

These core libraries allow the 32u4 and SAMD based boards (Leonardo, Esplora, Zero, Due and MKR Family) to appear as a native Mouse and/or Keyboard to a connected computer.

**A word of caution on using the Mouse and Keyboard libraries**: if the Mouse or Keyboard library is constantly running, it will be difficult to program your board. Functions such as

```
<span><span>Mouse</span><span>.</span><span>move</span><span>(</span><span>)</span></span>
```

and

```
<span><span>Keyboard</span><span>.</span><span>print</span><span>(</span><span>)</span></span>
```

will move your cursor or send keystrokes to a connected computer and should only be called when you are ready to handle them. It is recommended to use a control system to turn this functionality on, like a physical switch or only responding to specific input you can control. Refer to the Mouse and Keyboard examples for some ways to handle this.

When using the Mouse or Keyboard library, it may be best to test your output first using [Serial.print()](https://docs.arduino.cc/language-reference/en/functions/communication/serial/print). This way, you can be sure you know what values are being reported.

## Functions

-   [Keyboard.begin()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardBegin)
-   [Keyboard.end()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardEnd)
-   [Keyboard.press()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardPress)
-   [Keyboard.print()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardPrint)
-   [Keyboard.println()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardPrintln)
-   [Keyboard.release()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardRelease)
-   [Keyboard.releaseAll()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardReleaseAll)
-   [Keyboard.write()](https://docs.arduino.cc/language-reference/en/functions/usb/Keyboard/keyboardWrite)

## See also

-   [KeyboardAndMouseControl](http://www.arduino.cc/en/Tutorial/KeyboardAndMouseControl): Demonstrates the Mouse and Keyboard commands in one program.
-   [KeyboardMessage](http://www.arduino.cc/en/Tutorial/KeyboardMessage): Sends a text string when a button is pressed.
-   [KeyboardLogout](http://www.arduino.cc/en/Tutorial/KeyboardLogout): Logs out the current user with key commands
-   [KeyboardSerial](http://www.arduino.cc/en/Tutorial/KeyboardSerial): Reads a byte from the serial port, and sends back a keystroke.
-   [KeyboardReprogram^](http://www.arduino.cc/en/Tutorial/KeyboardReprogram): Opens a new window in the Arduino IDE and reprograms the board with a simple blink program

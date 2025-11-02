# Serial Passthrough for Keyboard Emulation

## Overview

This solution allows you to send text from your computer's clipboard to your Arduino, which will then type it out on a host computer. It is particularly useful for typing languages like Hebrew, where the Arduino Keyboard library's direct support is limited by the host OS's keyboard layout.

This directory contains two scripts that accomplish the same task:
*   `send_clipboard.py` (for Python users)
*   `send_clipboard.ps1` (for Windows PowerShell users)

---

## How It Works

1.  **Arduino Sketch:** You upload a special sketch (`SerialToKeyboard.ino`) to your Arduino. This sketch simply listens for any character sent over the USB serial port and types it as a keystroke.
2.  **Computer Script:** You run a script on your computer that reads text from your clipboard and sends it, character by character, to the Arduino's serial port. The Arduino receives each character and types it out.

---

## ⚙️ Setup Instructions

### Step 1: Program the Arduino

1.  Open the Arduino IDE.
2.  Go to `File > Examples > Keyboard > examples > SerialToKeyboard`.
3.  Open the `SerialToKeyboard.ino` sketch.
4.  Connect your Arduino board (e.g., Pro Micro, Leonardo) to your computer.
5.  Select the correct board and port in the `Tools` menu.
6.  Upload the sketch to your Arduino.

### Step 2: Set Host Keyboard Layout

**This is the most important step.**

The computer that the Arduino will be typing on (the **host computer**) **MUST** have its keyboard input language set to **Hebrew**. The scripts only send the key positions; the host computer is responsible for interpreting them as Hebrew characters.

---

## 🚀 Usage Instructions

After setting up the Arduino, you can now use one of the scripts below to send text to it.

### Option A: Using the Python Script

**1. Install Dependencies:**
   Open a terminal or command prompt and install the required Python libraries:
   ```sh
   pip install pyserial pyperclip
   ```

**2. Run the Script:**
   1.  Copy the Hebrew text you want to type to your clipboard.
   2.  Navigate to this `scripts` directory in your terminal.
   3.  Run the script:
       ```sh
       python send_clipboard.py
       ```
   4.  The script will automatically find your Arduino and send the text from your clipboard.

### Option B: Using the PowerShell Script (Windows)

**1. No Dependencies Needed:**
   This script uses built-in Windows functionality.

**2. Run the Script:**
   1.  Copy the Hebrew text you want to type to your clipboard.
   2.  In the file explorer, navigate to this `scripts` directory.
   3.  Right-click on `send_clipboard.ps1` and select **"Run with PowerShell"**.

   **Note on Execution Policy:** If the script doesn't run, your PowerShell execution policy might be blocking it. You can allow it to run for the current session by opening PowerShell and running this command:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
   Then, try running the script again.

---

## 🔧 Troubleshooting

*   **"Error: Could not find a connected Arduino."**
    *   Make sure your Arduino is plugged into the computer.
    *   Ensure the correct drivers for your Arduino are installed.
    *   Check that no other program (like the Arduino IDE's Serial Monitor) is currently connected to the Arduino's serial port.

*   **The Arduino misses characters or types gibberish.**
    *   This can happen if the text is sent too quickly. Open the `.py` or `.ps1` script in a text editor and increase the `CHARACTER_DELAY` (in the Python script) or `$CharacterDelay` (in the PowerShell script) value. For example, change it from `0.05` to `0.1` (or `50` to `100` in PowerShell).

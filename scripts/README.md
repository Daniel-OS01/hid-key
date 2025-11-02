# GUI-Based Keyboard Sender for Arduino

## Overview

This solution provides a graphical user interface (GUI) to send text from your computer to an Arduino, which will then type it out on a host computer. It is ideal for typing in languages like Hebrew, offering more control and better feedback than a simple command-line script.

This directory contains two GUI applications that accomplish the same task:
*   `gui_sender.py` (a cross-platform Python application)
*   `gui_sender.ps1` (a native Windows PowerShell application)

---

## ✨ Features

*   **Interactive GUI:** A user-friendly window for controlling the application.
*   **Live Text Input:** Type or paste directly into a large text box.
*   **Clipboard Integration:** A dedicated button to send text directly from your clipboard.
*   **Advanced Troubleshooting:**
    *   **COM Port Selector:** Manually select the Arduino's serial port from a dropdown list.
    *   **Refresh Button:** Rescan for connected devices without restarting the application.
    *   **Adjustable Typing Speed:** Control the delay between each character to ensure reliable typing on slower host computers.
*   **Real-Time Feedback:** A status bar tells you exactly what the application is doing (e.g., "Connecting...", "Sending...", "Done.").

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

The computer that the Arduino will be typing on (the **host computer**) **MUST** have its keyboard input language set to **Hebrew**. The application only sends the key positions; the host computer is responsible for interpreting them as Hebrew characters.

---

## 🚀 Usage Instructions

Choose the application that best fits your system.

### Option A: Using the Python GUI

**1. Install Dependencies:**
   Open a terminal or command prompt and install the required Python libraries:
   ```sh
   pip install pyserial pyperclip
   ```

**2. Launch the Application:**
   1.  Navigate to this `scripts` directory in your terminal.
   2.  Run the script:
       ```sh
       python gui_sender.py
       ```

**3. Using the Interface:**
   1.  Click the **Refresh** button to scan for your Arduino.
   2.  Select your Arduino's **COM Port** from the dropdown menu.
   3.  (Optional) Adjust the **Char Delay (ms)** if you find that characters are being missed. A higher number means slower, more reliable typing.
   4.  Enter text by either typing/pasting into the main text box and clicking **Send Text**, or by copying text to your clipboard and clicking **Send from Clipboard**.
   5.  Watch the status bar at the bottom for feedback.

### Option B: Using the PowerShell GUI (Windows)

**1. No Dependencies Needed:**
   This script uses built-in Windows functionality.

**2. Launch the Application:**
   1.  In the file explorer, navigate to this `scripts` directory.
   2.  Right-click on `gui_sender.ps1` and select **"Run with PowerShell"**.

   **Note on Execution Policy:** If the script doesn't run, your PowerShell execution policy might be blocking it. You can allow it to run for the current session by opening PowerShell and running this command:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
   Then, try running the script again.

**3. Using the Interface:**
   The PowerShell GUI functions identically to the Python version. Follow the same steps as described in "Using the Interface" above.

---

## 🔧 Troubleshooting

*   **No COM ports appear in the dropdown:**
    *   Ensure your Arduino is securely connected to the computer.
    *   Check that the correct drivers for your Arduino are installed.
    *   Make sure no other program (like the Arduino IDE's Serial Monitor) is using the port.
    *   Click the **Refresh** button to scan again.

*   **The application freezes or characters are missed:**
    *   Increase the **Char Delay (ms)** value. Start with `100` and adjust as needed. This gives the host computer more time to process each keystroke.

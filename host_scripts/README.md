# Host-Side Helper Scripts

These scripts are designed to send Hebrew text from your computer to an Arduino running a `SerialToKeyboard` sketch. They handle the translation from the Hebrew character set to the corresponding US QWERTY keystrokes that the Arduino expects. They also introduce a small delay between each character to prevent the Arduino's buffer from overflowing, which is a common issue when pasting large amounts of text.

This directory contains both command-line and GUI versions of the scripts.

## GUI Applications

The easiest way to use this tool is with the graphical user interface.

### Python GUI (`send_hebrew_gui.py`)

![Python GUI Screenshot](https://i.imgur.com/your-screenshot.png) <!-- It's helpful to add a screenshot -->

**Requirements:**
- Python 3
- `pyserial` library: `pip install pyserial`
- `pyperclip` library: `pip install pyperclip`

**To Run:**
```bash
python send_hebrew_gui.py
```

### PowerShell GUI (`send_hebrew_gui.ps1`)

![PowerShell GUI Screenshot](https://i.imgur.com/your-screenshot.png) <!-- It's helpful to add a screenshot -->

**Requirements:**
- PowerShell 5.1 or later (standard on Windows 10 and 11)

**To Run:**
Open a PowerShell terminal and run the script. You may need to change the execution policy:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\send_hebrew_gui.ps1
```

### GUI Features
- **Text Area:** A large box to type or paste the Hebrew text you want to send.
- **Serial Port Dropdown:** Automatically detects and lists available serial ports. Use the **Refresh** button if you plug in your Arduino after opening the app.
- **Baud Rate & Delay:** Set the communication speed and the delay (in milliseconds) between each character. A delay of 10-20ms is recommended for pasting.
- **Send/Stop Button:** Starts or stops the sending process. The button text changes to "Stop Sending" while active.
- **Paste from Clipboard:** A convenient button to paste text directly into the text area.
- **Clear Text:** Clears the text area.
- **Log Window:** Shows a real-time log of the application's activity, including connection status, which characters are being sent, and any errors. This is very useful for troubleshooting.
- **Status Bar:** Displays the current status (e.g., "Ready", "Sending...", "Error").

---

## Command-Line Scripts

For users who prefer the command line.

### `send_hebrew.py` (Python)

**Usage:**
1.  **Find Your Arduino's Serial Port:**
    -   **Windows:** `COM3`, `COM4`, etc. (Check Device Manager)
    -   **Linux/macOS:** `/dev/ttyACM0`, `/dev/cu.usbmodem...`, etc.
2.  **Copy Hebrew Text:** Copy the text you want to type to your clipboard.
3.  **Run the Script:**
    ```bash
    python send_hebrew.py <YOUR_SERIAL_PORT>
    ```
    Example:
    ```bash
    python send_hebrew.py COM3 --delay 0.03
    ```

### `send_hebrew.ps1` (PowerShell)

**Usage:**
```powershell
.\send_hebrew.ps1 -Port <YOUR_SERIAL_PORT>
```
Example:
```powershell
.\send_hebrew.ps1 -Port COM3 -Delay 30
```

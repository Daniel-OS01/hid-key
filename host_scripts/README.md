# Host-Side Helper Scripts

These scripts are designed to send Hebrew text from your computer's clipboard to an Arduino running a `SerialToKeyboard` sketch. They handle the translation from the Hebrew character set to the corresponding US QWERTY keystrokes that the Arduino expects. They also introduce a small delay between each character to prevent the Arduino's buffer from overflowing, which is a common issue when pasting large amounts of text.

## Requirements

### Python Script (`send_hebrew.py`)

- Python 3
- `pyserial` library: `pip install pyserial`
- `pyperclip` library: `pip install pyperclip`

### PowerShell Script (`send_hebrew.ps1`)

- PowerShell 5.1 or later (standard on Windows 10 and 11)
- No special dependencies are required.

## Usage

1.  **Upload a `SerialToKeyboard` Sketch to Your Arduino:**
    Make sure your Arduino (e.g., a Pro Micro) is programmed with one of the `ProMicro_SerialToKeyboard` examples from this repository. The `_Slow` or `_Adaptive` versions are recommended for pasted text.

2.  **Find Your Arduino's Serial Port:**
    -   **Windows:** Open the Device Manager, look under "Ports (COM & LPT)". Your Arduino will likely appear as "Arduino Leonardo" or a similar name, followed by a COM port (e.g., `COM3`).
    -   **Linux:** Open a terminal and run `dmesg | grep tty`. Your Arduino will likely be listed as `/dev/ttyACM0` or similar.
    -   **macOS:** Open a terminal and run `ls /dev/cu.usbmodem*`.

3.  **Copy Hebrew Text:**
    Copy the Hebrew text you want to type to your clipboard.

4.  **Run the Script:**

    ### Python
    ```bash
    python send_hebrew.py <YOUR_SERIAL_PORT>
    ```
    Example:
    ```bash
    python send_hebrew.py COM3
    ```
    You can also adjust the delay between characters:
    ```bash
    python send_hebrew.py COM3 --delay 0.03
    ```

    ### PowerShell
    Open a PowerShell terminal. You may need to change the execution policy to run the script:
    ```powershell
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    ```
    Then run the script:
    ```powershell
    .\send_hebrew.ps1 -Port <YOUR_SERIAL_PORT>
    ```
    Example:
    ```powershell
    .\send_hebrew.ps1 -Port COM3
    ```
    You can also adjust the delay:
    ```powershell
    .\send_hebrew.ps1 -Port COM3 -Delay 30
    ```

The script will then connect to the Arduino and begin typing the text from your clipboard.

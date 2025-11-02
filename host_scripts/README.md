# Host-Side Helper Scripts

This directory contains scripts to send Hebrew text from your computer to an Arduino running a `SerialToKeyboard` sketch.

## Recommended Utility: `HEBREW_KEYBOARD_UTILITY.py`

This is the recommended tool for sending text. It is a graphical application that contains all the latest bug fixes and features.

### Requirements
- Python 3
- Dependencies listed in `requirements.txt`

### Setup
1.  Install the required Python packages:
    ```bash
    pip install -r requirements.txt
    ```

### How to Run
1.  Launch the application:
    ```bash
    python HEBREW_KEYBOARD_UTILITY.py
    ```
2.  Select your Arduino's **Serial Port** from the dropdown menu. Use the **Refresh** button if you don't see it.
3.  Type or paste Hebrew text into the text box.
4.  Click the **Send Text** button.

### Features
- **Prevents Arduino Reset:** Uses the correct DTR signal handling to avoid the "PermissionError" on subsequent uses.
- **Correct Character Mapping:** Includes the fully corrected Hebrew-to-QWERTY character map.
- **User-Friendly GUI:** Provides a simple interface with a text area, port selection, logging, and status updates.

---

## Legacy Scripts (Deprecated)

The following scripts are older and may contain bugs. It is recommended to **delete them** and use the `HEBREW_KEYBOARD_UTILITY.py` instead to avoid confusion.

- `send_hebrew.py`
- `send_hebrew_gui.py`
- `send_hebrew.ps1`
- `send_hebrew_gui.ps1`

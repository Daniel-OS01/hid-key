# gui_sender.py
#
# A graphical user interface for sending text from your computer to an
# Arduino running the SerialToKeyboard sketch.
#
# Dependencies:
#   pip install pyserial pyperclip
#
# Usage:
#   1. Make sure your Arduino is connected.
#   2. Run this script: python gui_sender.py
#   3. A window will appear. Use it to send text to the Arduino.

import tkinter as tk
from tkinter import ttk
import serial
import serial.tools.list_ports
import pyperclip
import threading
import time

class App:
    def __init__(self, master):
        self.master = master
        self.master.title("Arduino Hebrew Keyboard Sender")
        self.master.geometry("500x450")

        # --- Member Variables ---
        self.serial_port = None

        # --- UI Elements ---
        # Frame for connection and settings
        settings_frame = ttk.Frame(master, padding="10")
        settings_frame.pack(fill=tk.X)

        # Port selection
        ttk.Label(settings_frame, text="COM Port:").grid(row=0, column=0, sticky="w", padx=5)
        self.port_combobox = ttk.Combobox(settings_frame, state="readonly")
        self.port_combobox.grid(row=0, column=1, sticky="ew", padx=5)
        self.refresh_button = ttk.Button(settings_frame, text="Refresh", command=self.update_port_list)
        self.refresh_button.grid(row=0, column=2, padx=5)

        # Delay setting
        ttk.Label(settings_frame, text="Char Delay (ms):").grid(row=1, column=0, sticky="w", padx=5, pady=5)
        self.delay_var = tk.StringVar(value="50")
        self.delay_entry = ttk.Entry(settings_frame, textvariable=self.delay_var, width=10)
        self.delay_entry.grid(row=1, column=1, sticky="w", padx=5, pady=5)

        settings_frame.columnconfigure(1, weight=1)

        # Main text entry box
        text_frame = ttk.Frame(master, padding="10")
        text_frame.pack(fill=tk.BOTH, expand=True)

        self.text_entry = tk.Text(text_frame, wrap="word", height=10, width=50)
        self.text_entry.pack(fill=tk.BOTH, expand=True)

        # Buttons
        button_frame = ttk.Frame(master, padding="10")
        button_frame.pack(fill=tk.X)

        self.send_button = ttk.Button(button_frame, text="Send Text", command=self.on_send_from_box)
        self.send_button.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5)

        self.clipboard_button = ttk.Button(button_frame, text="Send from Clipboard", command=self.on_send_from_clipboard)
        self.clipboard_button.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=5)

        # Status bar
        self.status_var = tk.StringVar(value="Ready. Refresh ports to begin.")
        self.status_bar = ttk.Label(master, textvariable=self.status_var, relief=tk.SUNKEN, anchor="w", padding="5")
        self.status_bar.pack(side=tk.BOTTOM, fill=tk.X)

        # --- Initial Setup ---
        self.update_port_list()

    def update_status(self, message):
        self.status_var.set(message)
        self.master.update_idletasks()

    def update_port_list(self):
        self.update_status("Scanning for COM ports...")
        ports = serial.tools.list_ports.comports()
        port_names = [port.device for port in ports]
        self.port_combobox['values'] = port_names

        if not port_names:
            self.update_status("No COM ports found. Connect Arduino and refresh.")
            return

        # Try to auto-select an Arduino
        for port in ports:
            if "Arduino" in port.description or "USB-SERIAL" in port.description:
                self.port_combobox.set(port.device)
                self.update_status(f"Ready. Found Arduino on {port.device}")
                return

        self.port_combobox.set(port_names[0])
        self.update_status(f"Ready. Using default port {port_names[0]}")

    def on_send_from_box(self):
        text = self.text_entry.get("1.0", tk.END).strip()
        if text:
            self.start_send_thread(text)
        else:
            self.update_status("Text box is empty.")

    def on_send_from_clipboard(self):
        try:
            text = pyperclip.paste()
            if text:
                self.start_send_thread(text)
            else:
                self.update_status("Clipboard is empty.")
        except Exception as e:
            self.update_status(f"Error reading clipboard: {e}")

    def start_send_thread(self, text_to_send):
        # Disable buttons to prevent multiple sends
        self.send_button.config(state=tk.DISABLED)
        self.clipboard_button.config(state=tk.DISABLED)

        # Run the sending logic in a separate thread to keep the GUI responsive
        thread = threading.Thread(target=self.send_text_task, args=(text_to_send,))
        thread.daemon = True
        thread.start()

    def send_text_task(self, text_to_send):
        port_name = self.port_combobox.get()
        if not port_name:
            self.update_status("Error: No COM port selected.")
            self.send_button.config(state=tk.NORMAL)
            self.clipboard_button.config(state=tk.NORMAL)
            return

        try:
            delay_ms = int(self.delay_var.get())
            delay_s = delay_ms / 1000.0
        except ValueError:
            self.update_status("Error: Invalid delay. Must be a number (ms).")
            self.send_button.config(state=tk.NORMAL)
            self.clipboard_button.config(state=tk.NORMAL)
            return

        try:
            self.update_status(f"Opening port {port_name}...")
            with serial.Serial(port_name, 9600, timeout=1) as ser:
                time.sleep(2)  # Wait for Arduino to initialize

                total = len(text_to_send)
                for i, char in enumerate(text_to_send):
                    self.update_status(f"Sending char {i+1}/{total}: '{char}'")
                    ser.write(char.encode('utf-8'))
                    time.sleep(delay_s)

            self.update_status("Text sent successfully.")

        except serial.SerialException as e:
            self.update_status(f"Error: {e}")
        finally:
            # Re-enable buttons
            self.send_button.config(state=tk.NORMAL)
            self.clipboard_button.config(state=tk.NORMAL)

if __name__ == "__main__":
    root = tk.Tk()
    app = App(root)
    root.mainloop()

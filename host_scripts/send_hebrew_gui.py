import tkinter as tk
from tkinter import ttk, scrolledtext
import serial
import serial.tools.list_ports
import pyperclip
import time
import threading

# Hebrew to US QWERTY keyboard mapping
HEBREW_QWERTY_MAP = {
    'א': 't', 'ב': 'c', 'ג': 'd', 'ד': 's', 'ה': 'v', 'ו': 'u',
    'ז': 'z', 'ח': 'j', 'ט': 'y', 'י': 'h', 'כ': 'f', 'ל': 'k',
    'מ': 'n', 'נ': 'b', 'ס': 'x', 'ע': 'g', 'פ': 'p', 'צ': 'm',
    'ק': 'e', 'ר': 'r', 'ש': 'a', 'ת': ',', 'ך': 'l', 'ם': 'o',
    'ן': 'i', 'ף': ';', 'ץ': ',',
    '~': '`', '!': '1', '@': '2', '#': '3', '$': '4', '%': '5',
    '^': '6', '&': '7', '*': '8', '(': '9', ')': '0', '_': '-',
    '+': '=', ',': '.', '/': 'q', '.': '/', "'": "'", ';': 'w',
    '\\': '\\', '[': ']', ']': '[',
}

class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Hebrew Keyboard Sender")
        self.geometry("600x650")

        self.sending_thread = None
        self.sending = False
        self.ser = None # To hold the serial object

        self.create_widgets()
        self.update_ports()
        self.protocol("WM_DELETE_WINDOW", self.on_closing)

    def create_widgets(self):
        # (GUI widget creation code remains the same as before)
        main_frame = ttk.Frame(self, padding="10")
        main_frame.pack(fill=tk.BOTH, expand=True)
        ttk.Label(main_frame, text="Enter or Paste Hebrew Text Here:").pack(anchor=tk.W)
        self.text_area = scrolledtext.ScrolledText(main_frame, height=10, width=70, wrap=tk.WORD)
        self.text_area.pack(fill=tk.BOTH, expand=True)
        controls_frame = ttk.LabelFrame(main_frame, text="Controls", padding="10")
        controls_frame.pack(fill=tk.X, pady=10)
        ttk.Label(controls_frame, text="Serial Port:").grid(row=0, column=0, padx=5, pady=5, sticky=tk.W)
        self.port_var = tk.StringVar()
        self.port_menu = ttk.Combobox(controls_frame, textvariable=self.port_var, width=20)
        self.port_menu.grid(row=0, column=1, padx=5, pady=5, sticky=tk.W)
        self.refresh_button = ttk.Button(controls_frame, text="Refresh", command=self.update_ports)
        self.refresh_button.grid(row=0, column=2, padx=5, pady=5)
        ttk.Label(controls_frame, text="Baud Rate:").grid(row=1, column=0, padx=5, pady=5, sticky=tk.W)
        self.baud_var = tk.StringVar(value="9600")
        ttk.Entry(controls_frame, textvariable=self.baud_var, width=10).grid(row=1, column=1, padx=5, pady=5, sticky=tk.W)
        ttk.Label(controls_frame, text="Delay (ms):").grid(row=1, column=2, padx=5, pady=5, sticky=tk.W)
        self.delay_var = tk.StringVar(value="20")
        ttk.Entry(controls_frame, textvariable=self.delay_var, width=10).grid(row=1, column=3, padx=5, pady=5, sticky=tk.W)
        buttons_frame = ttk.Frame(main_frame)
        buttons_frame.pack(fill=tk.X, pady=5)
        self.send_button = ttk.Button(buttons_frame, text="Send Text", command=self.start_sending)
        self.send_button.pack(side=tk.LEFT, padx=5)
        self.paste_button = ttk.Button(buttons_frame, text="Paste from Clipboard", command=self.paste_from_clipboard)
        self.paste_button.pack(side=tk.LEFT, padx=5)
        self.clear_button = ttk.Button(buttons_frame, text="Clear Text", command=self.clear_text)
        self.clear_button.pack(side=tk.LEFT, padx=5)
        log_frame = ttk.LabelFrame(main_frame, text="Log", padding="10")
        log_frame.pack(fill=tk.BOTH, expand=True, pady=10)
        self.log_area = scrolledtext.ScrolledText(log_frame, height=10, width=70, state='disabled', wrap=tk.WORD)
        self.log_area.pack(fill=tk.BOTH, expand=True)
        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(main_frame, textvariable=self.status_var, relief=tk.SUNKEN, anchor=tk.W).pack(fill=tk.X)

    def log(self, message):
        self.log_area.config(state='normal')
        self.log_area.insert(tk.END, message + "\n")
        self.log_area.config(state='disabled')
        self.log_area.see(tk.END)

    def update_ports(self):
        ports = [port.device for port in serial.tools.list_ports.comports()]
        self.port_menu['values'] = ports
        if ports:
            self.port_var.set(ports[0])
            self.log("Updated serial port list.")
        else:
            self.port_var.set("")
            self.log("No serial ports found.")

    def paste_from_clipboard(self):
        try:
            text = pyperclip.paste()
            self.text_area.delete('1.0', tk.END)
            self.text_area.insert('1.0', text)
            self.log("Pasted text from clipboard.")
        except Exception as e:
            self.log(f"Error pasting from clipboard: {e}")

    def clear_text(self):
        self.text_area.delete('1.0', tk.END)
        self.log("Text area cleared.")

    def start_sending(self):
        if self.sending:
            self.log("Already sending text.")
            return

        port = self.port_var.get()
        if not port:
            self.log("Error: Please select a serial port.")
            self.status_var.set("Error: No port selected")
            return

        text = self.text_area.get('1.0', tk.END).strip()
        if not text:
            self.log("Error: Text area is empty.")
            self.status_var.set("Error: Text is empty")
            return

        self.sending = True
        self.send_button.config(text="Stop Sending", command=self.stop_sending)
        self.status_var.set("Sending...")
        self.log("Starting to send text...")
        self.sending_thread = threading.Thread(target=self.send_text_worker, args=(text, port), daemon=True)
        self.sending_thread.start()

    def stop_sending(self):
        self.sending = False # Signal the worker thread to stop
        self.log("Sending stopped by user.")

    def on_closing(self):
        if self.sending:
            self.stop_sending() # Ensure thread is signaled to stop
            if self.sending_thread:
                self.sending_thread.join(timeout=1.0) # Wait for thread to finish
        self.destroy()

    def send_text_worker(self, text, port):
        self.ser = None
        try:
            baudrate = int(self.baud_var.get())
            delay_ms = int(self.delay_var.get())
            delay_s = delay_ms / 1000.0
        except ValueError:
            self.log("Error: Invalid baud rate or delay. Please enter numbers.")
            self.sending = False
            self.send_button.config(text="Send Text", command=self.start_sending)
            return

        try:
            self.ser = serial.Serial()
            self.ser.port = port
            self.ser.baudrate = baudrate
            self.ser.timeout = 1
            # Disable DTR to prevent the Arduino Pro Micro from resetting
            self.ser.dtr = False
            self.ser.open()

            self.log(f"Connected to {port} at {baudrate} baud.")
            for char in text:
                if not self.sending:
                    break

                if char in HEBREW_QWERTY_MAP:
                    qwerty_char = HEBREW_QWERTY_MAP[char]
                    self.ser.write(qwerty_char.encode('ascii'))
                    self.log(f"Sent '{qwerty_char}' for Hebrew '{char}'")
                elif ' ' <= char <= '~':
                    self.ser.write(char.encode('ascii'))
                    self.log(f"Sent ASCII '{char}'")
                elif char == '\n':
                    self.ser.write(b'\r')
                    self.log("Sent newline (CR)")
                else:
                    self.log(f"Skipping unsupported char: '{char}'")

                time.sleep(delay_s)

            if self.sending: # If it finished without being stopped
                self.log("Finished sending text.")
                self.status_var.set("Done")
            else: # If it was stopped by the user
                self.status_var.set("Stopped")

        except serial.SerialException as e:
            self.log(f"Serial Error: {e}")
            self.status_var.set("Error: Serial connection failed")
        except Exception as e:
            self.log(f"An unexpected error occurred: {e}")
            self.status_var.set("Error")
        finally:
            if self.ser and self.ser.is_open:
                self.ser.close()
                self.log("Serial port closed.")
            self.sending = False
            self.send_button.config(text="Send Text", command=self.start_sending)

if __name__ == "__main__":
    app = App()
    app.mainloop()

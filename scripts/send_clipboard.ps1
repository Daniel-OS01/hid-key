# send_clipboard.ps1
#
# This script reads text from the clipboard and sends it to an Arduino
# running the SerialToKeyboard sketch. This allows you to type Hebrew
# or any other language by sending it to the Arduino.
#
# Usage:
#   1. Copy the Hebrew text you want to type to your clipboard.
#   2. Right-click this file and select "Run with PowerShell".
#   3. The script will find the Arduino and send the text.

# --- Configuration ---
$BaudRate = 9600
# Delay between each character sent to the Arduino (in milliseconds).
# Increase this if characters are being missed.
$CharacterDelay = 50

function Find-ArduinoPort {
    <#
    .SYNOPSIS
        Scans for a connected Arduino and returns its COM port.
    #>
    Write-Host "Scanning for connected Arduino..."

    # Get all Plug and Play devices that look like a serial port
    $devices = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Name -like '* (COM*)' }

    foreach ($device in $devices) {
        # Check if the device name/caption contains "Arduino" or a common USB-to-Serial chip name
        if ($device.Name -like "*Arduino*" -or $device.Caption -like "*USB-SERIAL*") {
            # Extract the COM port from the name (e.g., "Arduino Uno (COM3)")
            if ($device.Name -match '(COM\d+)') {
                $port = $Matches[0]
                Write-Host "Found Arduino on port: $port"
                return $port
            }
        }
    }

    # If no specific device was found, return nothing
    return $null
}

# --- Main Script ---
$arduinoPortName = Find-ArduinoPort

if (-not $arduinoPortName) {
    Write-Error "Could not find a connected Arduino. Please ensure it's plugged in."
    # Pause to allow the user to read the error before the window closes.
    Start-Sleep -Seconds 10
    exit 1
}

$textToSend = Get-Clipboard
if ([string]::IsNullOrEmpty($textToSend)) {
    Write-Host "Clipboard is empty. Please copy some text and run the script again."
    Start-Sleep -Seconds 5
    exit
}

Write-Host "Will send the following text from clipboard:"
Write-Host "---"
Write-Host $textToSend
Write-Host "---"

# Create and configure the serial port object
$port = New-Object System.IO.Ports.SerialPort
$port.PortName = $arduinoPortName
$port.BaudRate = $BaudRate
$port.DtrEnable = $true # Data Terminal Ready, often needed to reset the Arduino

try {
    $port.Open()
    # Wait for the Arduino to initialize after the serial connection is made
    Write-Host "Waiting for Arduino to initialize..."
    Start-Sleep -Seconds 2

    Write-Host "Sending text..."
    foreach ($char in $textToSend.ToCharArray()) {
        $port.Write($char)
        Start-Sleep -Milliseconds $CharacterDelay
    }
    Write-Host "Text sent successfully."
    Start-Sleep -Seconds 3

}
catch {
    Write-Error "An error occurred while sending data: $_"
    Start-Sleep -Seconds 10
}
finally {
    if ($port.IsOpen) {
        $port.Close()
    }
    $port.Dispose()
}

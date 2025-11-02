# gui_sender.ps1
#
# A graphical user interface for sending text from your computer to an
# Arduino running the SerialToKeyboard sketch. This script is for Windows
# and uses PowerShell with Windows Forms.
#
# Usage:
#   1. Make sure your Arduino is connected.
#   2. Right-click this file and select "Run with PowerShell".
#   3. A window will appear. Use it to send text to the Arduino.

# --- Load .NET Assemblies for GUI ---
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Create Main Form ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Arduino Hebrew Keyboard Sender"
$form.Size = New-Object System.Drawing.Size(520, 500)
$form.StartPosition = "CenterScreen"

# --- Create UI Controls ---

# 1. Port Selection Label and ComboBox
$portLabel = New-Object System.Windows.Forms.Label
$portLabel.Text = "COM Port:"
$portLabel.Location = New-Object System.Drawing.Point(10, 15)
$portLabel.Size = New-Object System.Drawing.Size(80, 20)
$form.Controls.Add($portLabel)

$portComboBox = New-Object System.Windows.Forms.ComboBox
$portComboBox.Location = New-Object System.Drawing.Point(90, 12)
$portComboBox.Size = New-Object System.Drawing.Size(280, 20)
$portComboBox.DropDownStyle = "DropDownList" # Make it read-only
$portComboBox.Anchor = "Top, Left, Right"
$form.Controls.Add($portComboBox)

# 2. Refresh Button
$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh"
$refreshButton.Location = New-Object System.Drawing.Point(380, 11)
$refreshButton.Size = New-Object System.Drawing.Size(110, 23)
$refreshButton.Anchor = "Top, Right"
$form.Controls.Add($refreshButton)

# 3. Delay Label and TextBox
$delayLabel = New-Object System.Windows.Forms.Label
$delayLabel.Text = "Char Delay (ms):"
$delayLabel.Location = New-Object System.Drawing.Point(10, 45)
$delayLabel.Size = New-Object System.Drawing.Size(100, 20)
$form.Controls.Add($delayLabel)

$delayTextBox = New-Object System.Windows.Forms.TextBox
$delayTextBox.Text = "50"
$delayTextBox.Location = New-Object System.Drawing.Point(120, 42)
$delayTextBox.Size = New-Object System.Drawing.Size(60, 20)
$form.Controls.Add($delayTextBox)

# 4. Main Text Box
$mainTextBox = New-Object System.Windows.Forms.TextBox
$mainTextBox.Location = New-Object System.Drawing.Point(10, 75)
$mainTextBox.Size = New-Object System.Drawing.Size(480, 280)
$mainTextBox.MultiLine = $true
$mainTextBox.ScrollBars = "Vertical"
$mainTextBox.Font = New-Object System.Drawing.Font("Arial", 10)
$mainTextBox.Anchor = "Top, Bottom, Left, Right"
$form.Controls.Add($mainTextBox)

# 5. Send Buttons
$sendButton = New-Object System.Windows.Forms.Button
$sendButton.Text = "Send Text"
$sendButton.Location = New-Object System.Drawing.Point(10, 365)
$sendButton.Size = New-Object System.Drawing.Size(235, 30)
$sendButton.Anchor = "Bottom, Left, Right"
$form.Controls.Add($sendButton)

$clipboardButton = New-Object System.Windows.Forms.Button
$clipboardButton.Text = "Send from Clipboard"
$clipboardButton.Location = New-Object System.Drawing.Point(255, 365)
$clipboardButton.Size = New-Object System.Drawing.Size(235, 30)
$clipboardButton.Anchor = "Bottom, Left, Right"
$form.Controls.Add($clipboardButton)

# 6. Status Bar
$statusBar = New-Object System.Windows.Forms.Label
$statusBar.Text = "Ready. Refresh ports to begin."
$statusBar.Location = New-Object System.Drawing.Point(0, 410)
$statusBar.Size = New-Object System.Drawing.Size($form.Width, 30)
$statusBar.BorderStyle = "Fixed3D"
$statusBar.Anchor = "Bottom, Left, Right"
$form.Controls.Add($statusBar)


# --- Functions ---
function Update-Status($message) {
    $statusBar.Text = "  $message"
    [System.Windows.Forms.Application]::DoEvents() # Force UI update
}

function Update-PortList {
    Update-Status "Scanning for COM ports..."
    $portComboBox.Items.Clear()
    $selectedPort = $null

    # Get devices and add them to the ComboBox
    $devices = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object { $_.Name -like '* (COM*)' }
    foreach ($device in $devices) {
        if ($device.Name -match '(COM\d+)') {
            $portName = $Matches[0]
            $portComboBox.Items.Add($portName)
            if ($device.Name -like "*Arduino*" -or $device.Caption -like "*USB-SERIAL*") {
                $selectedPort = $portName
            }
        }
    }

    if ($portComboBox.Items.Count -gt 0) {
        $portComboBox.SelectedItem = if ($selectedPort) { $selectedPort } else { $portComboBox.Items[0] }
        Update-Status "Ready. Found ports."
    } else {
        Update-Status "No COM ports found. Connect Arduino and refresh."
    }
}

function Send-Text($textToSend) {
    if ([string]::IsNullOrEmpty($textToSend)) {
        Update-Status "Nothing to send."
        return
    }

    $sendButton.Enabled = $false
    $clipboardButton.Enabled = $false

    $portName = $portComboBox.SelectedItem
    if (-not $portName) {
        Update-Status "Error: No COM port selected."
        $sendButton.Enabled = $true
        $clipboardButton.Enabled = $true
        return
    }

    try {
        $delayMs = [int]$delayTextBox.Text
    } catch {
        Update-Status "Error: Invalid delay. Must be a number (ms)."
        $sendButton.Enabled = $true
        $clipboardButton.Enabled = $true
        return
    }

    $port = New-Object System.IO.Ports.SerialPort
    $port.PortName = $portName
    $port.BaudRate = 9600

    try {
        Update-Status "Opening port $portName..."
        $port.Open()
        Start-Sleep -Seconds 2 # Wait for Arduino to initialize

        $total = $textToSend.Length
        for ($i = 0; $i -lt $total; $i++) {
            $char = $textToSend[$i]
            Update-Status "Sending char $($i+1)/$total: '$char'"
            $port.Write($char)
            Start-Sleep -Milliseconds $delayMs
        }
        Update-Status "Text sent successfully."
    }
    catch {
        Update-Status "Error: $($_.Exception.Message)"
    }
    finally {
        if ($port.IsOpen) {
            $port.Close()
        }
        $port.Dispose()
        $sendButton.Enabled = $true
        $clipboardButton.Enabled = $true
    }
}

# --- Event Handlers ---
$refreshButton.Add_Click({ Update-PortList })
$sendButton.Add_Click({ Send-Text $mainTextBox.Text })
$clipboardButton.Add_Click({ Send-Text $(Get-Clipboard) })

# --- Initial Load and Show Form ---
Update-PortList # Initial scan on startup
$form.ShowDialog()

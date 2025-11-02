#Requires -Version 5.1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Hebrew to US QWERTY keyboard mapping
$script:hebrewQwertyMap = @{
    'א' = 't'; 'ב' = 'c'; 'ג' = 'd'; 'ד' = 's'; 'ה' = 'v'; 'ו' = 'u';
    'ז' = 'z'; 'ח' = 'j'; 'ט' = 'y'; 'י' = 'h'; 'כ' = 'f'; 'ל' = 'k';
    'מ' = 'n'; 'נ' = 'b'; 'ס' = 'x'; 'ע' = 'g'; 'פ' = 'p'; 'צ' = 'm';
    'ק' = 'e'; 'ר' = 'r'; 'ש' = 'a'; 'ת' = 'w'; 'ך' = 'l'; 'ם' = 'o';
    'ן' = 'i'; 'ף' = 'q'; 'ץ' = ',';
    '~' = '`'; '!' = '1'; '@' = '2'; '#' = '3'; '$' = '4'; '%' = '5';
    '^' = '6'; '&' = '7'; '*' = '8'; '(' = '9'; ')' = '0'; '_' = '-';
    '+' = '='; ',' = '.'; '/' = ';'; '.' = '/'; "'" = "'"; ';' = 'w';
    '\' = '\'; '[' = ']'; ']' = '[';
}

$script:sendingJob = $null

# --- Form Creation ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Hebrew Keyboard Sender (PowerShell)"
$form.Size = New-Object System.Drawing.Size(620, 700)
$form.StartPosition = 'CenterScreen'

# --- Main Controls ---
$labelTextArea = New-Object System.Windows.Forms.Label
$labelTextArea.Text = "Enter or Paste Hebrew Text Here:"
$labelTextArea.Location = New-Object System.Drawing.Point(10, 10)
$labelTextArea.AutoSize = $true
$form.Controls.Add($labelTextArea)

$textArea = New-Object System.Windows.Forms.TextBox
$textArea.Multiline = $true
$textArea.ScrollBars = 'Vertical'
$textArea.Location = New-Object System.Drawing.Point(10, 30)
$textArea.Size = New-Object System.Drawing.Size(580, 150)
$textArea.Font = New-Object System.Drawing.Font("Arial", 12)
$form.Controls.Add($textArea)

# --- Controls GroupBox ---
$controlsGroup = New-Object System.Windows.Forms.GroupBox
$controlsGroup.Text = "Controls"
$controlsGroup.Location = New-Object System.Drawing.Point(10, 190)
$controlsGroup.Size = New-Object System.Drawing.Size(580, 90)
$form.Controls.Add($controlsGroup)

$labelPort = New-Object System.Windows.Forms.Label
$labelPort.Text = "Serial Port:"
$labelPort.Location = New-Object System.Drawing.Point(10, 25)
$labelPort.AutoSize = $true
$controlsGroup.Controls.Add($labelPort)

$portComboBox = New-Object System.Windows.Forms.ComboBox
$portComboBox.Location = New-Object System.Drawing.Point(80, 22)
$portComboBox.Size = New-Object System.Drawing.Size(120, 20)
$controlsGroup.Controls.Add($portComboBox)

$refreshButton = New-Object System.Windows.Forms.Button
$refreshButton.Text = "Refresh"
$refreshButton.Location = New-Object System.Drawing.Point(210, 20)
$controlsGroup.Controls.Add($refreshButton)

$labelBaud = New-Object System.Windows.Forms.Label
$labelBaud.Text = "Baud Rate:"
$labelBaud.Location = New-Object System.Drawing.Point(10, 55)
$labelBaud.AutoSize = $true
$controlsGroup.Controls.Add($labelBaud)

$baudTextBox = New-Object System.Windows.Forms.TextBox
$baudTextBox.Text = "9600"
$baudTextBox.Location = New-Object System.Drawing.Point(80, 52)
$baudTextBox.Size = New-Object System.Drawing.Size(70, 20)
$controlsGroup.Controls.Add($baudTextBox)

$labelDelay = New-Object System.Windows.Forms.Label
$labelDelay.Text = "Delay (ms):"
$labelDelay.Location = New-Object System.Drawing.Point(160, 55)
$labelDelay.AutoSize = $true
$controlsGroup.Controls.Add($labelDelay)

$delayTextBox = New-Object System.Windows.Forms.TextBox
$delayTextBox.Text = "20"
$delayTextBox.Location = New-Object System.Drawing.Point(230, 52)
$delayTextBox.Size = New-Object System.Drawing.Size(50, 20)
$controlsGroup.Controls.Add($delayTextBox)

# --- Action Buttons ---
$sendButton = New-Object System.Windows.Forms.Button
$sendButton.Text = "Send Text"
$sendButton.Location = New-Object System.Drawing.Point(10, 290)
$form.Controls.Add($sendButton)

$pasteButton = New-Object System.Windows.Forms.Button
$pasteButton.Text = "Paste from Clipboard"
$pasteButton.Location = New-Object System.Drawing.Point(100, 290)
$form.Controls.Add($pasteButton)

$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Clear Text"
$clearButton.Location = New-Object System.Drawing.Point(230, 290)
$form.Controls.Add($clearButton)

# --- Log Area ---
$logGroup = New-Object System.Windows.Forms.GroupBox
$logGroup.Text = "Log"
$logGroup.Location = New-Object System.Drawing.Point(10, 330)
$logGroup.Size = New-Object System.Drawing.Size(580, 280)
$form.Controls.Add($logGroup)

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.Dock = 'Fill'
$logGroup.Controls.Add($logBox)

# --- Status Bar ---
$statusBar = New-Object System.Windows.Forms.StatusBar
$statusBar.Text = "Ready"
$form.Controls.Add($statusBar)

# --- Functions ---
$log = {
    param($message)
    if ($logBox.InvokeRequired) {
        $logBox.Invoke([Action[string]]$log, $message)
    } else {
        $logBox.AppendText("$message`r`n")
    }
}

$updatePorts = {
    $portComboBox.Items.Clear()
    [System.IO.Ports.SerialPort]::GetPortNames() | ForEach-Object {
        $portComboBox.Items.Add($_)
    }
    if ($portComboBox.Items.Count -gt 0) {
        $portComboBox.SelectedIndex = 0
        $log.Invoke("Updated serial port list.")
    } else {
        $log.Invoke("No serial ports found.")
    }
}

$sendLogic = {
    param($text, $portName, $baudRate, $delayMs)
    $serialPort = New-Object System.IO.Ports.SerialPort($portName, $baudRate)
    try {
        $serialPort.Open()
        $log.Invoke("Connected to $portName at $baudRate baud.")

        foreach ($char in $text.ToCharArray()) {
            if ($script:sendingJob.IsStopped) {
                $log.Invoke("Sending stopped by user.")
                break
            }
            if ($script:hebrewQwertyMap.ContainsKey($char)) {
                $qwertyChar = $script:hebrewQwertyMap[$char]
                $serialPort.Write($qwertyChar)
                $log.Invoke("Sent '$qwertyChar' for Hebrew '$char'")
            } elseif ($char -ge ' ' -and $char -le '~') {
                $serialPort.Write([string]$char)
                $log.Invoke("Sent ASCII '$char'")
            } elseif ($char -eq "`n") {
                $serialPort.Write("`r")
                $log.Invoke("Sent newline (CR)")
            } else {
                $log.Invoke("Skipping unsupported character: '$char'")
            }
            Start-Sleep -Milliseconds $delayMs
        }
    } catch {
        $log.Invoke("Serial Error: $($_.Exception.Message)")
        $statusBar.Text = "Error: Serial connection failed"
    } finally {
        if ($serialPort.IsOpen) {
            $serialPort.Close()
        }
        $sendButton.Text = "Send Text"
        if(-not $script:sendingJob.IsStopped) {
            $statusBar.Text = "Done."
        }
    }
}

# --- Event Handlers ---
$refreshButton.Add_Click({ $updatePorts.Invoke() })

$pasteButton.Add_Click({
    $textArea.Text = Get-Clipboard
    $log.Invoke("Pasted text from clipboard.")
})

$clearButton.Add_Click({
    $textArea.Clear()
    $log.Invoke("Text area cleared.")
})

$sendButton.Add_Click({
    if ($script:sendingJob) {
        Stop-Job $script:sendingJob
        $script:sendingJob = $null
        $statusBar.Text = "Stopped"
        $sendButton.Text = "Send Text"
    } else {
        if (-not $portComboBox.SelectedItem) {
            $log.Invoke("Error: Please select a serial port.")
            $statusBar.Text = "Error: No port selected"
            return
        }
        if ([string]::IsNullOrWhiteSpace($textArea.Text)) {
            $log.Invoke("Error: Text area is empty.")
            $statusBar.Text = "Error: Text is empty"
            return
        }

        $sendButton.Text = "Stop Sending"
        $statusBar.Text = "Sending..."
        $script:sendingJob = Start-Job -ScriptBlock $sendLogic -ArgumentList $textArea.Text, $portComboBox.SelectedItem, $baudTextBox.Text, $delayTextBox.Text
    }
})

$form.Add_Shown({ $updatePorts.Invoke() })
$form.Add_FormClosing({ if($script:sendingJob) { Stop-Job $script:sendingJob } })

# --- Show Form ---
[void]$form.ShowDialog()

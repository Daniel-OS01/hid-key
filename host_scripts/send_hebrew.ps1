#Requires -Version 5.1

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Port,

    [int]$BaudRate = 9600,

    [int]$Delay = 20 # Delay in milliseconds
)

# Hebrew to US QWERTY keyboard mapping
$hebrewQwertyMap = @{
    'א' = 't'; 'ב' = 'c'; 'ג' = 'd'; 'ד' = 's'; 'ה' = 'v'; 'ו' = 'u';
    'ז' = 'z'; 'ח' = 'j'; 'ט' = 'y'; 'י' = 'h'; 'כ' = 'f'; 'ל' = 'k';
    'מ' = 'n'; 'נ' = 'b'; 'ס' = 'x'; 'ע' = 'g'; 'פ' = 'p'; 'צ' = 'm';
    'ק' = 'e'; 'ר' = 'r'; 'ש' = 'a'; 'ת' = ','; 'ך' = 'l'; 'ם' = 'o';
    'ן' = 'i'; 'ף' = ';'; 'ץ' = ',';
    # Shifted characters
    '~' = '`'; '!' = '1'; '@' = '2'; '#' = '3'; '$' = '4'; '%' = '5';
    '^' = '6'; '&' = '7'; '*' = '8'; '(' = '9'; ')' = '0'; '_' = '-';
    '+' = '=';
    # Punctuation
    ',' = '.'; '/' = 'q'; '.' = '/'; "'" = "'"; ';' = 'w'; '\' = '\';
    '[' = ']'; ']' = '[';
}

$clipboardText = Get-Clipboard

if ([string]::IsNullOrEmpty($clipboardText)) {
    Write-Warning "Clipboard is empty. Please copy some Hebrew text."
    exit
}

$serialPort = New-Object System.IO.Ports.SerialPort($Port, $BaudRate)

try {
    $serialPort.Open()
    Write-Host "Connected to $Port at $BaudRate baud."
    Write-Host "Sending text from clipboard..."

    foreach ($char in $clipboardText.ToCharArray()) {
        $qwertyChar = $null
        if ($hebrewQwertyMap.ContainsKey($char)) {
            $qwertyChar = $hebrewQwertyMap[$char]
            $serialPort.Write($qwertyChar)
            Write-Host "Sent '$qwertyChar' for Hebrew char '$char'"
        }
        elseif ($char -ge ' ' -and $char -le '~') { # Regular ASCII characters
            $serialPort.Write($char)
            Write-Host "Sent ASCII char '$char'"
        }
        elseif ($char -eq "`n") {
            $serialPort.Write("`r") # Send carriage return for newline
            Write-Host "Sent newline"
        }
        else {
            Write-Host "Skipping unsupported character: '$char'"
        }

        Start-Sleep -Milliseconds $Delay
    }

    Write-Host "Done."
}
catch {
    Write-Error "Error: Could not open serial port $Port. Please check the port and permissions."
    Write-Error $_.Exception.Message
}
finally {
    if ($serialPort.IsOpen) {
        $serialPort.Close()
    }
}

$proxy=$($args[0])
$bypassList=$($args[1])

if (([string]::IsNullOrEmpty($proxy))) {
    $proxy=""
}

if (([string]::IsNullOrEmpty($bypassList))) {
    $bypassList="localhost"
}

echo "INFO: proxy: '${proxy}'"
echo "INFO: bypassList '${bypassList}'"

netsh winhttp set proxy $proxy bypass-list=$bypassList

foreach ($account in "LOCALSYSTEM","NETWORKSERVICE","LOCALSERVICE") {
    & C:\windows\System32\bitsadmin.exe /Util /SetIEProxy $account Manual_proxy $proxy $bypassList
}

$proxyString = ""
for ($i = 0;$i -lt (([System.Text.Encoding]::Unicode.GetBytes($proxy)).length); $i++) {
    if ($i % 2 -eq 0) {
        $byte = (([System.Text.Encoding]::Unicode.GetBytes($proxy))[$i])
        $convertedByte=%{[System.Convert]::ToString($byte,16)}
        $proxyString = $proxystring + $convertedByte  + ","
    }
}

$bypassString = ""
for ($i = 0;$i -lt (([System.Text.Encoding]::Unicode.GetBytes($bypassList)).length); $i++) {
    if ($i % 2 -eq 0) {
        $byte = (([System.Text.Encoding]::Unicode.GetBytes($bypassList))[$i])
        $convertedByte=%{[System.Convert]::ToString($byte,16)}
        $bypassString = $bypassString + $convertedByte  + ","
    }
}

$regString="46,00,00,00,00,00,00,00,0b,00,00,00,"+(%{[System.Convert]::ToString($proxy.length,16)})+",00,00,00," + $proxystring + (%{[System.Convert]::ToString($bypassList.length,16)}) + ",00,00,00," + $bypassString +  "00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00"
$regstringAsArray = ("0x"+$regString.replace(",",",0x")).Split(",")
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $reg -Name ProxyServer -Value $proxy
Set-ItemProperty -Path $reg -Name ProxyEnable -Value 1
Set-ItemProperty -Path $reg -Name ProxyOverride -Value $bypassList
$reg = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections"
Set-ItemProperty -Path $reg -Name DefaultConnectionSettings -Type Binary -Value $regstringAsArray
Set-ItemProperty -Path $reg -Name SavedLegacySettings -Type Binary -Value $regstringAsArray

# All credits to https://stackoverflow.com/questions/48166882/using-powershell-to-programmatically-configure-internet-explorer-proxy-settings
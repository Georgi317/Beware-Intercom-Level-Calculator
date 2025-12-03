
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Список устройств (добавьте свои)
$Devices = @(
    @{ Name = "Наименование, ЖК"; IP = "IP_адрес домофона"; User = "admin"; Pass = "Пароль Вашего Домофона" },
)
    

# Форма
$form = New-Object System.Windows.Forms.Form
$form.Text = "Калькулятор уровней открытия и поднятия трубки"
$form.Size = New-Object System.Drawing.Size(1200, 560)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# Выбор устройства
$lblDev = New-Object System.Windows.Forms.Label
$lblDev.Text = "Устройство:"
$lblDev.Location = New-Object System.Drawing.Point(20, 15)
$form.Controls.Add($lblDev)

$cbDevice = New-Object System.Windows.Forms.ComboBox
$cbDevice.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$cbDevice.Location = New-Object System.Drawing.Point(120, 12)
$cbDevice.Size = New-Object System.Drawing.Size(260, 21)
$Devices | ForEach-Object { [void]$cbDevice.Items.Add($_.Name) }
if ($cbDevice.Items.Count -gt 0) { $cbDevice.SelectedIndex = 0 }
$form.Controls.Add($cbDevice)

# Ввод квартиры
$lblApt = New-Object System.Windows.Forms.Label
$lblApt.Text = "Квартира:"
$lblApt.Location = New-Object System.Drawing.Point(380, 15)
$form.Controls.Add($lblApt)

$tbApt = New-Object System.Windows.Forms.TextBox
$tbApt.Location = New-Object System.Drawing.Point(500, 12)
$tbApt.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($tbApt)

# Лог
$infoBox = New-Object System.Windows.Forms.TextBox
$infoBox.Multiline = $true
$infoBox.ReadOnly = $true
$infoBox.ScrollBars = "Vertical"
$infoBox.Location = New-Object System.Drawing.Point(20, 45)
$infoBox.Size = New-Object System.Drawing.Size(700, 250)
$infoBox.BackColor = [System.Drawing.Color]::White
$infoBox.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.Controls.Add($infoBox)

$btnClearLog = New-Object System.Windows.Forms.Button
$btnClearLog.Text = "Очистить лог"
$btnClearLog.Location = New-Object System.Drawing.Point(620, 12)
$btnClearLog.Size = New-Object System.Drawing.Size(100, 23)
$form.Controls.Add($btnClearLog)
function Write-Log($msg) {
    $infoBox.AppendText(("[$((Get-Date).ToString('HH:mm:ss'))] {0}`r`n" -f $msg))
}

# Текст инструкции
$instructions1 = @"
Шаг 1: Введите номер квартиры. Убедитесь, что трубка квартиры не снята, и нажмите кнопку «Равен». Справа появится число (например, 250) это будет Х2.
Шаг 2: Снимите трубку квартиры и нажмите кнопку «Равен». Справа появится число (например, 450) это будет Х1. «Уровень снятия трубки» вычисляется по формуле (X1-X2)/2+250. (450-250)/2+250.
Шаг 3: Зажмите и не отпускайте кнопку открытия двери на трубке. Нажмите кнопку «Равен». Справа появится число (например, 650). Отнимите от этого числа 50 и занесите результат в поле «Уровень открытия двери». X5 = X4 - 50
"@

# Информационное поле
$infoBox1 = New-Object System.Windows.Forms.TextBox
$infoBox1.Multiline = $true
$infoBox1.ReadOnly = $true
$infoBox1.Text = $instructions1
$infoBox1.ScrollBars = "None"
$infoBox1.Location = New-Object System.Drawing.Point(750, 45)
$infoBox1.Size = New-Object System.Drawing.Size(400, 200)
$infoBox1.BackColor = [System.Drawing.Color]::White
$infoBox1.Font = New-Object System.Drawing.Font("Arial", 10)
$form.Controls.Add($infoBox1)


#Информация
$instructions2 = @"
В ЖК Гвардейский стр1, Стр3 и Стр4
Вест Сайд Стр1, Стр2 и Стр3
Соколова Стр1 и Стр2 
присутствует префикс строения
номер квартиры начинается с цифры номера строения.
К примеру, если квартира 74, то набирать нужно 1075, 
если 152, то 1152 и т.д.
"@

# Информационное поле
$infoBox2 = New-Object System.Windows.Forms.TextBox
$infoBox2.Multiline = $true
$infoBox2.ReadOnly = $true
$infoBox2.Text = $instructions2
$infoBox2.ScrollBars = "None"
$infoBox2.Location = New-Object System.Drawing.Point(750, 300)
$infoBox2.Size = New-Object System.Drawing.Size(400, 150)
$infoBox2.BackColor = [System.Drawing.Color]::White
$infoBox2.Font = New-Object System.Drawing.Font("Arial", 10)
$form.Controls.Add($infoBox2)

# Поля X1/X2/X4
$labelX1 = New-Object System.Windows.Forms.Label
$labelX1.Text = "X1: трубка снята"
$labelX1.Location = New-Object System.Drawing.Point(20, 300)
$form.Controls.Add($labelX1)

$textX1 = New-Object System.Windows.Forms.TextBox
$textX1.Location = New-Object System.Drawing.Point(120, 300)
$textX1.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($textX1)

$labelX2 = New-Object System.Windows.Forms.Label
$labelX2.Text = "X2:трубка в покое"
$labelX2.Location = New-Object System.Drawing.Point(220, 300)
$form.Controls.Add($labelX2)

$textX2 = New-Object System.Windows.Forms.TextBox
$textX2.Location = New-Object System.Drawing.Point(340, 300)
$textX2.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($textX2)

$labelX4 = New-Object System.Windows.Forms.Label
$labelX4.Text = "X4:Кнопка нажата"
$labelX4.Location = New-Object System.Drawing.Point(20, 350)
$form.Controls.Add($labelX4)

$textX4 = New-Object System.Windows.Forms.TextBox
$textX4.Location = New-Object System.Drawing.Point(120, 350)
$textX4.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($textX4)

# Результаты
$labelResult = New-Object System.Windows.Forms.Label
$labelResult.Text = "X3 = "
$labelResult.Location = New-Object System.Drawing.Point(20, 400)
$labelResult.Size = New-Object System.Drawing.Size(150, 30)
$labelResult.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($labelResult)

$labelResultX5 = New-Object System.Windows.Forms.Label
$labelResultX5.Text = "X5 = "
$labelResultX5.Location = New-Object System.Drawing.Point(20, 445)
$labelResultX5.Size = New-Object System.Drawing.Size(150, 30)
$labelResultX5.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($labelResultX5)

# Кнопки локальных расчётов
#Рассчитать X3
$button = New-Object System.Windows.Forms.Button
$button.Text = "Рассчитать X3, уровень поднятия трубки"
$button.Location = New-Object System.Drawing.Point(460, 300)
$button.Size = New-Object System.Drawing.Size(120, 60)
$form.Controls.Add($button)
#Рассчитать X5
$buttonX5 = New-Object System.Windows.Forms.Button
$buttonX5.Text = "Рассчитать X5, уровень открытия двери"
$buttonX5.Location = New-Object System.Drawing.Point(460, 360)
$buttonX5.Size = New-Object System.Drawing.Size(120, 60)
$form.Controls.Add($buttonX5)

# Кнопки получения X2 и X1, X4
#Получить X2
$btnGetX2 = New-Object System.Windows.Forms.Button
$btnGetX2.Text = "Получить X2, трубка в покое"
$btnGetX2.Location = New-Object System.Drawing.Point(600, 300)
$btnGetX2.Size = New-Object System.Drawing.Size(100, 40)
$form.Controls.Add($btnGetX2)
#Получить X1
$btnGetX1 = New-Object System.Windows.Forms.Button
$btnGetX1.Text = "Получить X1, трубка поднята"
$btnGetX1.Location = New-Object System.Drawing.Point(600, 340)
$btnGetX1.Size = New-Object System.Drawing.Size(100, 40)
$form.Controls.Add($btnGetX1)
#Получить X4
$btnGetX4 = New-Object System.Windows.Forms.Button
$btnGetX4.Text = "Получить X4, кнопка зажата"
$btnGetX4.Location = New-Object System.Drawing.Point(600, 380)
$btnGetX4.Size = New-Object System.Drawing.Size(100, 40)
$form.Controls.Add($btnGetX4)

#Получить уровни
$btnSet1 = New-Object System.Windows.Forms.Button
$btnSet1.Text = "Проверить уровни"
$btnSet1.Location = New-Object System.Drawing.Point(440, 450)
$btnSet1.Size = New-Object System.Drawing.Size(140, 40)
$form.Controls.Add($btnSet1)

# Кнопка применения настроек
$btnSet = New-Object System.Windows.Forms.Button
$btnSet.Text = "Применить настройки"
$btnSet.Location = New-Object System.Drawing.Point(580, 450)
$btnSet.Size = New-Object System.Drawing.Size(140, 40)
$form.Controls.Add($btnSet)

# Helpers
function Get-SelectedDevice {
    param([string]$name)
    return $Devices | Where-Object { $_.Name -eq $name } | Select-Object -First 1
}

function New-AuthSession([string]$user, [string]$pass) {
    $sess = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    if ($user -and $pass) {
        $pair = "{0}:{1}" -f $user, $pass
        $basic = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
        $sess.Headers["Authorization"] = "Basic $basic"
    }
    return $sess
}

# Настройте URL под ваш API при необходимости
function Get-X2([string]$ip, [string]$apt, $sess) {
    $url = "http://$ip/cgi-bin/intercom_cgi?action=linelevel&Apartment=$apt"
    Invoke-WebRequest -Uri $url -WebSession $sess -TimeoutSec 10 -Method GET
}

function Get-X1([string]$ip, [string]$apt, $sess) {
    $url = "http://$ip/cgi-bin/intercom_cgi?action=linelevel&Apartment=$apt"
    Invoke-WebRequest -Uri $url -WebSession $sess -TimeoutSec 10 -Method GET
}

function Get-X4([string]$ip, [string]$apt, $sess) {
    $url = "http://$ip/cgi-bin/intercom_cgi?action=linelevel&Apartment=$apt"
    Invoke-WebRequest -Uri $url -WebSession $sess -TimeoutSec 10 -Method GET
}
function Set-Params([string]$ip, $sess, $handsetUpLevel, $doorOpenLevel) {
    $url = "http://$ip/cgi-bin/intercom_cgi?action=set&HandsetUpLevel=$handsetUpLevel&DoorOpenLevel=$doorOpenLevel&IndividualLevels=on"
    Invoke-WebRequest -Uri $url -WebSession $sess -TimeoutSec 10 -Method GET
}


function Get-Params([string]$ip, $sess) {
    $url = "http://$ip/cgi-bin/intercom_cgi?action=get&Apartment=$apt"

    Invoke-WebRequest -Uri $url -WebSession $sess -TimeoutSec 10 -Method GET
}


function Parse-KeyValue($content) {
    $lines = ($content -split '\r?\n') | Where-Object { $_ -match '=' }
    foreach ($ln in $lines) {
        if ($ln -match '^\s*([A-Za-z0-9_]+)\s*=\s*([-\d\.,]+)\s*$') {
            return @{ Key = $Matches[1]; Value = ($Matches[2] -replace ',', '.') }
        }
    }
    return $null
}

# Обработчики
$button.Add_Click({
        $X1 = $textX1.Text -replace ",", "."
        $X2 = $textX2.Text -replace ",", "."
        $v1 = 0.0; $v2 = 0.0
        if ([double]::TryParse($X1, [ref]$v1) -and [double]::TryParse($X2, [ref]$v2)) {
            $x3 = ($v1 - $v2) / 2 + 250
            $labelResult.Text = "X3 = $x3"
        }
        else {
            $labelResult.Text = ""
            Write-Log "Некорректные X1/X2"
        }
    })

$buttonX5.Add_Click({
        $X4 = $textX4.Text -replace ",", "."
        $v = 0.0
        if ([double]::TryParse($X4, [ref]$v)) {
            $x5 = $v - 50
            $labelResultX5.Text = "X5 = $x5"
        }
        else {
            $labelResultX5.Text = ""
            Write-Log "Некорректный X4"
        }
    })
#Обработка нажатия кнопки для X2 и запрос уровней
$btnGetX2.Add_Click({
        try {
            $sel = Get-SelectedDevice -name $cbDevice.Text
            if (-not $sel) { Write-Log "Выберите устройство."; return }
            $apt = $tbApt.Text.Trim()
            if (-not $apt) { Write-Log "Укажите номер квартиры."; return }
            $sess = New-AuthSession $sel.User $sel.Pass
            Write-Log "[$($sel.Name)] Запрос X2 для квартиры $apt"
            $resp = Get-X2 $sel.IP $apt $sess
            Write-Log ("X2: " + ($resp.Content | Out-String))
            $kv = Parse-KeyValue $resp.C
            ontent
            if ($kv -and $kv.Key -ieq 'X2') {
                $v = 0.0
                if (double::TryParse($kv.Value, [ref]$v)) { $textX2.Text = $v.ToString() }
            }
            else {
                Write-Log "Не найден X2 в ответе."
            }
        }
        catch {
            # Write-Log ("Ошибка X2: " + $($_Exception.Message))
        }
    })
#Обработка нажатия кнопки для X1 и запрос уровней
$btnGetX1.Add_Click({
        try {
            $sel = Get-SelectedDevice -name $cbDevice.Text
            if (-not $sel) { Write-Log "Выберите устройство."; return }
            $apt = $tbApt.Text.Trim()
            if (-not $apt) { Write-Log "Укажите номер квартиры."; return }
            $sess = New-AuthSession $sel.User $sel.Pass
            Write-Log "$($sel.Name) Запрос X1 для квартиры $apt..."
            $resp = Get-X1 $sel.IP $apt $sess
            Write-Log ("X1: " + ($resp.Content | Out-String))
            $kv = Parse-KeyValue $resp.Content
            if ($kv -and $kv.Key -ieq 'X1') {
                $v = 0.0
                if ([double]::TryParse($kv.Value, [ref]$v)) { $textX1.Text = $v.ToString() }
            } 
        }
        catch { Write-Log "Ошибка ...: $($_Exception.Message)" }
    })
#Обработка нажатия кнопки для X4 и запрос уровней
$btnGetX4.Add_Click({
        try {
            $sel = Get-SelectedDevice -name $cbDevice.Text
            if (-not $sel) { Write-Log "Выберите устройство."; return }
            $apt = $tbApt.Text.Trim()
            if (-not $apt) { Write-Log "Укажите номер квартиры."; return }
            $sess = New-AuthSession $sel.User $sel.Pass
            Write-Log "$($sel.Name) Запрос X4 для квартиры $apt..."
            $resp = Get-X4 $sel.IP $apt $sess
            Write-Log ("X4: " + ($resp.Content | Out-String))
            $kv = Parse-KeyValue $resp.Content
            if ($kv -and $kv.Key -ieq 'X4') {
                $v = 0.0
                if ([double]::TryParse($kv.Value, [ref]$v)) { $textX1.Text = $v.ToString() }
            } 
        }
        catch { Write-Log "Ошибка ...: $($_Exception.Message)" }
    })
#Отчистка лог файла
$btnClearLog.Add_Click({
        $infoBox.Clear()
    })

#Применение настроек (подставляем X3 и X5 и отправляем в домофон)
$btnSet.Add_Click({
        try {
            $sel = Get-SelectedDevice -name $cbDevice.Text
            if (-not $sel) { Write-Log "Выберите устройство."; return }
            $apt = $tbApt.Text.Trim()

            $h = ($labelResult.Text -replace '^\s*X3\s*=\s*', '').Trim()
            $d = ($labelResultX5.Text -replace '^\s*X5\s*=\s*', '').Trim()
            if (-not $h -or -not $d) { Write-Log "Сначала рассчитайте X3 и X5."; return }

            $sess = New-AuthSession $sel.User $sel.Pass
            Write-Log "Установка уровней: X3=$h, X5=$d (Apartment=$apt)"
            $resp = Set-Params $sel.IP $sess $h $d $apt
            Write-Log ("Status: {0}" -f $resp.StatusCode)
            Write-Log ("Content: " + ($resp.Content | Out-String))
            Write-Log "Готово."
        }
        catch {
            Write-Log ("Ошибка установки: " + $_.Exception.Message)
            Write-Log ($url)

            
        }
    })

$btnSet1.Add_Click({
        try {
            $sel = Get-SelectedDevice -name $cbDevice.Text
            if (-not $sel) { Write-Log "Выберите устройство."; return }
            $apt = $tbApt.Text.Trim()
            $sess = New-AuthSession $sel.User $sel.Pass
            $resp = Get-Params $sel.IP $sess 
            Write-Log ("Content: " + ($resp.Content | Out-String))
        }
        catch {
            Write-Log ("Ошибка установки: " + $_.Exception.Message)
            Write-Log ($url)
            
        }
    })


$form.Add_Shown({ $form.Activate() })

[void]$form.ShowDialog()

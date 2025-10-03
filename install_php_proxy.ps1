Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================
# Arquivo de log
# ============================
$logFile = "$PSScriptRoot\proxy_instalador.log"
function Write-Log($msg) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $logFile -Value "[$timestamp] $msg"
}

# ============================
# Registro para salvar credenciais
# ============================
$regPath = "HKCU:\Software\ProxyInstaller"
function Save-Credentials($proxy, $user, $pass) {
    $data = @{
        Proxy   = $proxy
        Usuario = $user
        Senha   = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($pass))
    }
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    foreach ($k in $data.Keys) {
        Set-ItemProperty -Path $regPath -Name $k -Value $data[$k] -Force
    }
    Write-Log "Credenciais salvas no Registro."
}

function Load-Credentials() {
    if (Test-Path $regPath) {
        $proxy   = (Get-ItemProperty -Path $regPath -Name Proxy).Proxy
        $usuario = (Get-ItemProperty -Path $regPath -Name Usuario).Usuario
        $senha64 = (Get-ItemProperty -Path $regPath -Name Senha).Senha
        $senha   = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($senha64))
        return @{ Proxy=$proxy; Usuario=$usuario; Senha=$senha }
    }
    return $null
}

# ============================
# Criar Formulário
# ============================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Instalador PHP via Proxy"
$form.Size = New-Object System.Drawing.Size(500,420)
$form.StartPosition = "CenterScreen"

# Labels
$labelProxy = New-Object System.Windows.Forms.Label
$labelProxy.Text = "Proxy (http://proxy:porta):"
$labelProxy.AutoSize = $true
$labelProxy.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($labelProxy)

$labelUsuario = New-Object System.Windows.Forms.Label
$labelUsuario.Text = "Usuário (ex: DOMINIO\usuario):"
$labelUsuario.AutoSize = $true
$labelUsuario.Location = New-Object System.Drawing.Point(10,80)
$form.Controls.Add($labelUsuario)

$labelSenha = New-Object System.Windows.Forms.Label
$labelSenha.Text = "Senha:"
$labelSenha.AutoSize = $true
$labelSenha.Location = New-Object System.Drawing.Point(10,140)
$form.Controls.Add($labelSenha)

# Campos de Texto
$txtProxy = New-Object System.Windows.Forms.TextBox
$txtProxy.Location = New-Object System.Drawing.Point(10,40)
$txtProxy.Size = New-Object System.Drawing.Size(450,20)
$form.Controls.Add($txtProxy)

$txtUsuario = New-Object System.Windows.Forms.TextBox
$txtUsuario.Location = New-Object System.Drawing.Point(10,100)
$txtUsuario.Size = New-Object System.Drawing.Size(450,20)
$form.Controls.Add($txtUsuario)

$txtSenha = New-Object System.Windows.Forms.TextBox
$txtSenha.Location = New-Object System.Drawing.Point(10,160)
$txtSenha.Size = New-Object System.Drawing.Size(450,20)
$txtSenha.UseSystemPasswordChar = $true
$form.Controls.Add($txtSenha)

# Checkbox salvar credenciais
$chkSalvar = New-Object System.Windows.Forms.CheckBox
$chkSalvar.Text = "Salvar credenciais"
$chkSalvar.AutoSize = $true
$chkSalvar.Location = New-Object System.Drawing.Point(10,190)
$form.Controls.Add($chkSalvar)

# Botões
$btnTestProxy = New-Object System.Windows.Forms.Button
$btnTestProxy.Text = "Testar Proxy"
$btnTestProxy.Location = New-Object System.Drawing.Point(30,230)
$btnTestProxy.Size = New-Object System.Drawing.Size(120,30)
$form.Controls.Add($btnTestProxy)

$btnTestCred = New-Object System.Windows.Forms.Button
$btnTestCred.Text = "Testar Usuário/Senha"
$btnTestCred.Location = New-Object System.Drawing.Point(180,230)
$btnTestCred.Size = New-Object System.Drawing.Size(160,30)
$form.Controls.Add($btnTestCred)

$btnInstalar = New-Object System.Windows.Forms.Button
$btnInstalar.Text = "Instalar PHP"
$btnInstalar.Location = New-Object System.Drawing.Point(360,230)
$btnInstalar.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($btnInstalar)

# ============================
# Funções auxiliares
# ============================
function Get-WebClient($proxyUrl, $usuario, $senha, $usarCredenciais=$true) {
    $wc = New-Object System.Net.WebClient
    $wc.Proxy = New-Object System.Net.WebProxy($proxyUrl, $true)
    if ($usarCredenciais -and $usuario -ne "" -and $senha -ne "") {
        $wc.Proxy.Credentials = New-Object System.Net.NetworkCredential($usuario, $senha)
    }
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    return $wc
}

# ============================
# Ações dos botões
# ============================
$btnTestProxy.Add_Click({
    try {
        $wc = Get-WebClient $txtProxy.Text "" "" $false
        $resp = $wc.DownloadString("https://www.google.com")
        if ($resp.Length -gt 0) {
            [System.Windows.Forms.MessageBox]::Show("🌍 O proxy respondeu (sem autenticação).", "Proxy OK")
            Write-Log "Proxy testado OK: $($txtProxy.Text)"
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("❌ Falha ao acessar via Proxy.`nErro: $($_.Exception.Message)", "Erro Proxy")
        Write-Log "Erro Proxy: $($_.Exception.Message)"
    }
})

$btnTestCred.Add_Click({
    try {
        $wc = Get-WebClient $txtProxy.Text $txtUsuario.Text $txtSenha.Text $true
        $resp = $wc.DownloadString("https://www.google.com")
        if ($resp.Length -gt 0) {
            [System.Windows.Forms.MessageBox]::Show("✅ Proxy + credenciais OK!", "Credenciais OK")
            Write-Log "Credenciais OK para $($txtUsuario.Text) em $($txtProxy.Text)"
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("❌ Falha ao autenticar no Proxy.`nErro: $($_.Exception.Message)", "Erro Credenciais")
        Write-Log "Erro credenciais: $($_.Exception.Message)"
    }
})

$btnInstalar.Add_Click({
    try {
        $wc = Get-WebClient $txtProxy.Text $txtUsuario.Text $txtSenha.Text $true
        $urlPHP = 'https://php.new/install/windows/8.4'
        [System.Windows.Forms.MessageBox]::Show("🔄 Baixando e instalando PHP...", "Instalação")
        Write-Log "Iniciando instalação PHP do site: $urlPHP"
        
        $conteudo = $wc.DownloadString($urlPHP)
        Invoke-Expression $conteudo

        [System.Windows.Forms.MessageBox]::Show("✅ PHP instalado com sucesso!", "Sucesso")
        Write-Log "Instalação PHP concluída com sucesso."
        
        if ($chkSalvar.Checked) {
            Save-Credentials $txtProxy.Text $txtUsuario.Text $txtSenha.Text
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("❌ Erro ao instalar PHP.`nErro: $($_.Exception.Message)", "Erro Instalação")
        Write-Log "Erro instalação: $($_.Exception.Message)"
    }
})

# ============================
# Carregar credenciais salvas
# ============================
$cred = Load-Credentials
if ($cred -ne $null) {
    $txtProxy.Text   = $cred.Proxy
    $txtUsuario.Text = $cred.Usuario
    $txtSenha.Text   = $cred.Senha
    $chkSalvar.Checked = $true
    Write-Log "Credenciais carregadas do Registro."
}

# Mostrar Formulário
$form.ShowDialog() | Out-Null

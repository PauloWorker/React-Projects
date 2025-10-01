Add-Type -AssemblyName System.Windows.Forms

# ============================
# Função para verificar elevação
# ============================
function Test-IsElevated {
    $current = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $current.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ============================
# Elevação + Bypass temporário
# ============================
# Só tenta relançar se for script .ps1
if ($MyInvocation.InvocationName -like "*.ps1") {
    if (-not (Test-IsElevated)) {
        $psExe = if (Get-Command pwsh -ErrorAction SilentlyContinue) { (Get-Command pwsh).Source } else { (Get-Command powershell).Source }
        $scriptPath = $PSCommandPath

        if ($scriptPath) {
            $quotedPath = "`"$scriptPath`""
            $startInfo = "-NoProfile -ExecutionPolicy Bypass -File $quotedPath"
            Start-Process -FilePath $psExe -ArgumentList $startInfo -Verb RunAs -WindowStyle Normal
        } else {
            [System.Windows.Forms.MessageBox]::Show("Execute este script como Administrador.", "Aviso")
        }
        exit
    }
}

# ============================
# Criar Formulário GUI
# ============================
$form = New-Object System.Windows.Forms.Form
$form.Text = "Configuração de Proxy"
$form.Size = New-Object System.Drawing.Size(420,300)
$form.StartPosition = "CenterScreen"

# Labels
$labelProxy = New-Object System.Windows.Forms.Label
$labelProxy.Text = "Proxy (ex: http://proxy.seudominio.com:8080):"
$labelProxy.AutoSize = $true
$labelProxy.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($labelProxy)

$labelUsuario = New-Object System.Windows.Forms.Label
$labelUsuario.Text = "Usuário (ex: DOMINIO\usuario):"
$labelUsuario.AutoSize = $true
$labelUsuario.Location = New-Object System.Drawing.Point(10,70)
$form.Controls.Add($labelUsuario)

$labelSenha = New-Object System.Windows.Forms.Label
$labelSenha.Text = "Senha:"
$labelSenha.AutoSize = $true
$labelSenha.Location = New-Object System.Drawing.Point(10,120)
$form.Controls.Add($labelSenha)

# Campos de texto
$txtProxy = New-Object System.Windows.Forms.TextBox
$txtProxy.Location = New-Object System.Drawing.Point(10,40)
$txtProxy.Size = New-Object System.Drawing.Size(380,20)
$form.Controls.Add($txtProxy)

$txtUsuario = New-Object System.Windows.Forms.TextBox
$txtUsuario.Location = New-Object System.Drawing.Point(10,90)
$txtUsuario.Size = New-Object System.Drawing.Size(380,20)
$form.Controls.Add($txtUsuario)

$txtSenha = New-Object System.Windows.Forms.TextBox
$txtSenha.Location = New-Object System.Drawing.Point(10,140)
$txtSenha.Size = New-Object System.Drawing.Size(380,20)
$txtSenha.UseSystemPasswordChar = $true
$form.Controls.Add($txtSenha)

# Botão OK
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object System.Drawing.Point(80,200)
$okButton.Size = New-Object System.Drawing.Size(100,30)
$form.Controls.Add($okButton)

# Botão Testar Conexão
$testButton = New-Object System.Windows.Forms.Button
$testButton.Text = "Testar Conexão"
$testButton.Location = New-Object System.Drawing.Point(200,200)
$testButton.Size = New-Object System.Drawing.Size(120,30)
$form.Controls.Add($testButton)

# ============================
# Função para configurar Proxy
# ============================
function Set-Proxy($proxyUrl, $usuario, $senhaPlain) {
    $secureSenha = ConvertTo-SecureString $senhaPlain -AsPlainText -Force
    $credencial = New-Object System.Management.Automation.PSCredential($usuario, $secureSenha)

    # 🔹 Configura o DefaultWebProxy (resolve erro 407)
    [System.Net.WebRequest]::DefaultWebProxy = New-Object System.Net.WebProxy($proxyUrl, $true)
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = $credencial

    # 🔹 Monta proxy com credenciais para variáveis de ambiente
    $uriProxy = [System.Uri]$proxyUrl
    $senhaEncoded = [System.Uri]::EscapeDataString($senhaPlain)
    $proxyComCredenciais = "$($uriProxy.Scheme)://$usuario`:$senhaEncoded@$($uriProxy.Host):$($uriProxy.Port)"

    # Define variáveis de ambiente permanentes (opcional)
    setx HTTP_PROXY  $proxyComCredenciais | Out-Null
    setx HTTPS_PROXY $proxyComCredenciais | Out-Null

    [System.Windows.Forms.MessageBox]::Show("✅ Proxy configurado com sucesso!`nFeche e reabra o PowerShell.", "Sucesso")
}

# ============================
# Ações dos Botões
# ============================
$okButton.Add_Click({
    Set-Proxy $txtProxy.Text $txtUsuario.Text $txtSenha.Text
})

$testButton.Add_Click({
    try {
        $secureSenha = ConvertTo-SecureString $txtSenha.Text -AsPlainText -Force
        $credencial = New-Object System.Management.Automation.PSCredential($txtUsuario.Text, $secureSenha)
        $response = Invoke-WebRequest -Uri "https://www.google.com" -Proxy $txtProxy.Text -ProxyCredential $credencial -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            [System.Windows.Forms.MessageBox]::Show("🌍 Conexão bem-sucedida com o Google via Proxy!", "Teste OK")
        } else {
            [System.Windows.Forms.MessageBox]::Show("⚠️ Resposta inesperada: $($response.StatusCode)", "Aviso")
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("❌ Falha ao conectar via Proxy.`nErro: $($_.Exception.Message)", "Erro")
    }
})

# Mostrar Formulário
$form.ShowDialog() | Out-Null

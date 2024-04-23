if ($(Get-Service -Name ssh-agent).Status -ne 'Running')
{   
    # https://stackoverflow.com/a/57035712/1973777
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
        exit;
    }

    Set-Service ssh-agent -StartupType Automatic
    Start-Service ssh-agent
    Write-Output "SSH-Agent Started..."
}
else
{
    Write-Output "SSH-Agent Already Running..."
}
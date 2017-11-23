<#
    .SYNOPSIS
    Removes all trusted hosts.
    
    .DESCRIPTION
    Removes all trusted hosts by setting the WSMan:\localhost\Client\TrustedHosts value to ''.

    .EXAMPLE
    Clear-TrustedHost
#>
function Clear-TrustedHost {
    [CmdletBinding()]
    param()

    Set-Item WSMan:\localhost\Client\TrustedHosts -Value '' -Force
}
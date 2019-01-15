<#
    .SYNOPSIS
    Gets the list of trusted hosts.

    .DESCRIPTION
    Gets the list of trusted hosts by splitting the WSMan:\localhost\Client\TrustedHosts value on commas.

    .PARAMETER Pattern
    Optional regular expression. If this parameter is included then only trusted hosts that match the regular expression are returned.

    .EXAMPLE
    Get-TrustedHost

    Returns all trusted hosts.

    .EXAMPLE
    Get-TrustedHost ^192
#>

function Get-TrustedHost {
    [CmdletBinding()]
    [OutputType([String[]])]
    param(
        [String]
        $Pattern    
    )
    
    $trustedHosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value

    if ($trustedHosts -eq '') {
        @()
    }
    else {
        if ([String]::IsNullOrWhiteSpace($Pattern)) {
            $trustedHosts.Split(',')
        }
        else {
            $trustedHosts.Split(',') | Where-Object { $_ -match $Pattern }
        }
    }
}

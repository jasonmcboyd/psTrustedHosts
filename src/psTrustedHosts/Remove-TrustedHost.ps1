<#
    .SYNOPSIS
    Removes the specified trusted hosts.

    .DESCRIPTION
    Removes the specified trusted hosts from the WSMan:\localhost\Client\TrustedHosts value.

    .PARAMETER Computer
    Specifies the trusted hosts to be removed.

    .EXAMPLE
    Remove-TrustedHost 192.168.0.101

    Removes 192.168.0.101 from WSMan:\localhost\Client\TrustedHosts value.

    .EXAMPLE
    Get-TrustedHost ^192 | Remove-TrustedHost

    Removes all trusted hosts that start with '192'.
#>
function Remove-TrustedHost {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true)]
        [String[]]
        $Computer
    )

    Begin {
        $trustedHosts = @(Get-TrustedHost)
    }
    Process {
        $trustedHosts = $trustedHosts | Where-Object { $Computer -notcontains $_ }
    }
    End {
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value ($trustedHosts -join ',' ) -Force
    }
}
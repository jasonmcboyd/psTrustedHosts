<#
    .SYNOPSIS
    Adds trusted hosts. Only unique hosts are added (i.e. hosts will not be added if they already exist).

    .DESCRIPTION
    Converts the trusted hosts to comma seperated string and appends them to the WSMan:\localhost\Client\TrustedHosts value.

    .PARAMETER Computer
    Specifies the trusted hosts to be added. This parameter is required and cannot be null, empty, or blank.

    .EXAMPLE
    Add-TrustedHost 192.168.0.101

    Adds 192.168.0.101 to the trusted hosts.

    .EXAMPLE
    Add-TrustedHost 192.168.0.101, 192.168.0.102

    Adds 192.168.0.101 and 192.168.0.102 to the trusted hosts.

    .EXAMPLE
    101..120 | % { "192.168.0.$_" } | Add-TrustedHost

    Adds 192.168.0.101 through 192.168.0.120 to the trusted hosts.
#>
function Add-TrustedHost {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [String[]]
        $Computer
    )

    Begin {
        $trustedHosts = Get-TrustedHost
        if ($trustedHosts -eq $null) {
            $trustedHosts = @()
        }
        elseif($trustedHosts -is [String]) {
            $trustedHosts = @(,$trustedHosts)
        }
    }
    Process {
        # if ($Computer -eq $null -or ($Computer -is [string] -and [string]::IsNullOrWhiteSpace($Computer))) {
        if ($Computer -eq $null) {
            Write-Error "'Computer' cannot be null, empty, or white space."
        }

        foreach ($c in ($Computer)) {
            if ([string]::IsNullOrWhiteSpace($c)) {
                Write-Error "'Computer' cannot be null, empty, or white space."
            }
            elseif ($trustedHosts -notcontains $c) {
                $trustedHosts += $c
            }
        }
    }
    End {
        Set-Item WSMan:\localhost\Client\TrustedHosts -Value ($trustedHosts -join ',' ) -Force
    }
}
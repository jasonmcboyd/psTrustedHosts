Get-Module psTrustedHosts | Remove-Module -Force
Import-Module $PSScriptRoot\..\psTrustedHosts -Force

InModuleScope psTrustedHosts {
    Describe 'Clear-TrustedHost tests' {
        
        $testVariables = @{
            TrustedHostsString = ''
        }
        
        Mock `
            -CommandName Set-Item `
            -MockWith { 
                $testVariables.TrustedHostsString = $Value
            } `
            -ParameterFilter { $Path -eq 'WSMan:\localhost\Client\TrustedHosts' }

        $testCases = @(
            @{ Computer = $null }
            @{ Computer = '' }
            @{ Computer = 'host1' }
            @{ Computer = 'host1,host2' }
        )

        It "Clear-TrustedHost sets '<Computer>' to empty string" -TestCases $testCases {
            param (
                $Computer
            )

            $testVariables.TrustedHostsString = $Computer
            Clear-TrustedHost
            $testVariables.TrustedHostsString | Should -Be ''
        }
    }
}
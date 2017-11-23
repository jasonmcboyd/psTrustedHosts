Get-Module psTrustedhosts | Remove-Module
Import-Module $PSScriptRoot\..\psTrustedHosts

BeforeEachScenario {
    
    $Global:testVariables = @{
        TrustedHostsString = ''
    }

    Mock `
        -CommandName Set-Item `
        -ModuleName psTrustedHosts `
        -MockWith { 
            $testVariables.TrustedHostsString = $Value
        } `
        -ParameterFilter { $Path -eq 'WSMan:\localhost\Client\TrustedHosts' }
}

When "we invoke: Clear-TrustedHost" {
    
    Clear-TrustedHost
}
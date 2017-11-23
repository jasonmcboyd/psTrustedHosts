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

When "we invoke: Remove-TrustedHost -Computer (?<Computer>.*)" {
    param (
        [String[]]
        $Computer
    )

    $Computer = Invoke-Expression "$Computer"
    
    Remove-TrustedHost -Computer $Computer
}

When "we invoke: (?<Computer>.*) \| Remove-TrustedHost" {
    param (
        [String[]]
        $Computer
    )

    $computer = Invoke-Expression "$Computer"

    $Computer | Remove-TrustedHost
}
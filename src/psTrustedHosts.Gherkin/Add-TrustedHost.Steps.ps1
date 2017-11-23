Get-Module psTrustedhosts | Remove-Module
Import-Module $PSScriptRoot\..\psTrustedHosts

BeforeEachScenario {
    
    $Global:testVariables = @{
        TrustedHostsString = ''
        AddTrustedHostErrors = $null
    }
    
    Mock `
        -CommandName Set-Item `
        -ModuleName psTrustedHosts `
        -MockWith { 
            $testVariables.TrustedHostsString = $Value
        } `
        -ParameterFilter { $Path -eq 'WSMan:\localhost\Client\TrustedHosts' }
}

When "we invoke: Add-TrustedHost -Computer (?<Computer>.*)" {
    param (
        [String[]]
        $Computer
    )

    $Computer = Invoke-Expression "$Computer"
    
    $errorVariable = $null
    Add-TrustedHost -Computer $Computer -ErrorVariable errorVariable -ErrorAction SilentlyContinue
    $testVariables.AddTrustedHostErrors = $errorVariable
}

When "we invoke: (?<Computer>.*) \| Add-TrustedHost" {
    param (
        [String[]]
        $Computer
    )

    $computer = Invoke-Expression "$Computer"

    $errorVariable = $null
    $Computer | Add-TrustedHost -ErrorVariable errorVariable -ErrorAction SilentlyContinue
    $testVariables.AddTrustedHostErrors = $errorVariable
}
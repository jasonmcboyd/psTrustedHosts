Get-Module psTrustedhosts | Remove-Module
Import-Module $PSScriptRoot\..\psTrustedHosts

BeforeEachScenario {
    
    $Global:testVariables = @{
        TrustedHostsString = ''
    }

    Mock `
        -CommandName Get-Item `
        -ModuleName psTrustedHosts `
        -MockWith { 
            @{
                Value = $testVariables.TrustedHostsString
                Name = 'TrustedHosts'
            }
        } `
        -ParameterFilter { $Path -eq 'WSMan:\localhost\Client\TrustedHosts' }
}

When "we invoke: Get-TrustedHost, it yields (?<Expected>.*)" {
    param (
        [String[]]
        $Expected
    )

    $Expected = Invoke-Expression "$Expected"
    $actual = Get-TrustedHost
    $actual | Should -Be $Expected
}

When "we invoke: Get-TrustedHost -Pattern (?<Pattern>.*), it yields (?<Expected>.*)" {
    param (
        [String]
        $Pattern,

        [String[]]
        $Expected
    )

    $Expected = Invoke-Expression "$Expected"
    $actual = Get-TrustedHost -Pattern $Pattern
    $actual | Should -Be $Expected
}
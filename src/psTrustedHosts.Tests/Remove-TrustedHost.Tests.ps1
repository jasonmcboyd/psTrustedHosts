Get-Module psTrustedHosts | Remove-Module -Force
Import-Module $PSScriptRoot\..\psTrustedHosts -Force



InModuleScope psTrustedHosts {
    Describe 'Remove-TrustedHost tests' {
        
        $testVariables = @{
            TrustedHostsString = ''
        }

        Mock `
            -CommandName Get-Item `
            -MockWith { 
                @{
                    Value = $testVariables.TrustedHostsString
                    Name = 'TrustedHosts'
                }
            } `
            -ParameterFilter { $Path -eq 'WSMan:\localhost\Client\TrustedHosts' }
        
        Mock `
            -CommandName Set-Item `
            -MockWith { 
                $testVariables.TrustedHostsString = $Value
            } `
            -ParameterFilter { $Path -eq 'WSMan:\localhost\Client\TrustedHosts' }

        Context 'No trusted hosts' {
            BeforeEach {
                $testVariables.TrustedHostsString = ''
            }

            It 'Remove empty string' {
                Remove-TrustedHost -Computer ''
                
                $testVariables.TrustedHostsString | Should -Be ''
            }

            It 'Remove single host' {
                Remove-TrustedHost -Computer 'localhost'

                $testVariables.TrustedHostsString | Should -Be ''
            }

            It 'Remove multiple hosts by passing array' {
                Remove-TrustedHost -Computer 'host1', 'host2'

                $testVariables.TrustedHostsString | Should -Be ''
            }

            It 'Remove multiple hosts via pipeline' {
                @('host1','host2') | Remove-TrustedHost

                $testVariables.TrustedHostsString | Should -Be ''
            }

            It 'Removeing multiple hosts with duplicates does not result in duplicates' {
                Remove-TrustedHost -Computer 'host1', 'host2', 'host1'

                $testVariables.TrustedHostsString | Should -Be ''
            }
        }

        Context 'Single trusted host' {
            BeforeEach {
                $testVariables.TrustedHostsString = 'existingHost'
            }

            It 'Remove single host' {
                Remove-TrustedHost -Computer 'localhost'

                $testVariables.TrustedHostsString | Should -Be 'existingHost'
            }

            It 'Remove multiple hosts by passing array' {
                Remove-TrustedHost -Computer 'host1', 'host2'

                $testVariables.TrustedHostsString | Should -Be 'existingHost,host1,host2'
            }

            It 'Remove multiple hosts via pipeline' {
                @('host1','host2') | Remove-TrustedHost

                $testVariables.TrustedHostsString | Should -Be 'existingHost,host1,host2'
            }

            It 'Removeing multiple hosts with duplicates does not result in duplicates' {
                Remove-TrustedHost -Computer 'host1', 'host2', 'host1'

                $testVariables.TrustedHostsString | Should -Be 'existingHost,host1,host2'
            }

            It 'Removeing single host that already exists does not result in duplicate' {
                Remove-TrustedHost -Computer 'existingHost'
                
                $testVariables.TrustedHostsString | Should -Be 'existingHost'
            }
        }

        Context 'Multiple trusted hosts' {
            BeforeEach {
                $testVariables.TrustedHostsString = 'existingHost1,existingHost2'
            }

            It 'Remove single host' {
                Remove-TrustedHost -Computer 'localhost'

                $testVariables.TrustedHostsString | Should -Be 'existingHost1,existingHost2,localhost'
            }

            It 'Remove multiple hosts by passing array' {
                Remove-TrustedHost -Computer 'host1', 'host2'

                $testVariables.TrustedHostsString | Should -Be 'existingHost1,existingHost2,host1,host2'
            }

            It 'Remove multiple hosts via pipeline' {
                @('host1','host2') | Remove-TrustedHost

                $testVariables.TrustedHostsString | Should -Be 'existingHost1,existingHost2,host1,host2'
            }

            It 'Removeing multiple hosts with duplicates does not result in duplicates' {
                Remove-TrustedHost -Computer 'host1', 'host2', 'host1'

                $testVariables.TrustedHostsString | Should -Be 'existingHost1,existingHost2,host1,host2'
            }

            It 'Removeing single host that already exists does not result in duplicate' {
                Remove-TrustedHost -Computer 'existingHost1'
                
                $testVariables.TrustedHostsString | Should -Be 'existingHost1,existingHost2'
            }
        }
    }
}
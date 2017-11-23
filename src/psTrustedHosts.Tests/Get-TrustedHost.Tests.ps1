Get-Module psTrustedHosts | Remove-Module -Force
Import-Module $PSScriptRoot\..\psTrustedHosts -Force

InModuleScope psTrustedHosts {
    Describe 'Get-TrustedHost tests' {

        $testVariables = @{
            TrustedHostsString = 'test'
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

        Context 'No trusted hosts' {
            BeforeEach {
                $testVariables.TrustedHostsString = ''
            }

            $testCases = @(
                @{ Pattern = $null }
                @{ Pattern = '' }
                @{ Pattern = ' ' }
                @{ Pattern = '`t' }
                @{ Pattern = '`n' }
                @{ Pattern = 'host1' }
            )

            It 'no trusted hosts, Get-TrustedHost returns empty array' {
                
                $trustedHosts = Get-TrustedHost
                
                $trustedHosts | Should -be $null
            }
        
            It "no trusted hosts, Get-TrustedHost with '<Pattern>' as Pattern returns empty array" -TestCases $testCases {
                param (
                    $Pattern
                )

                $trustedHosts = Get-TrustedHost -Pattern $Pattern
                    
                $trustedHosts | Should -be $null
            }
        }

        Context 'Single trusted host' {
            BeforeEach {
                $testVariables.TrustedHostsString = 'host2'
            }

            It 'Get-TrustedHost returns single host' {
                $trustedHosts = Get-TrustedHost
                
                $trustedHosts | Should -BeOfType [System.String]
                $trustedHosts.Count | Should -Be 1
                $trustedHosts | Should -Be 'host2'
            }

            It 'Get-TrustedHosts with matching pattern returns single host' {
                $trustedHosts = Get-TrustedHost -Pattern 'host'
                
                $trustedHosts | Should -BeOfType [System.String]
                $trustedHosts.Count | Should -Be 1
                $trustedHosts | Should -Be 'host2'
            }

            It "Get-TrustedHosts without matching pattern returns no hosts" {
                
                $trustedHosts = Get-TrustedHost -Pattern 'host1'
                
                $trustedHosts | Should -be $null
            }
        }

        Context 'Multiple trusted hosts' {
            BeforeEach {
                $testVariables.TrustedHostsString = 'host1,host2'
            }

            It 'Get-TrustedHost returns all hosts' {
                
                $trustedHosts = Get-TrustedHost
                
                $trustedHosts -is [Object[]] | Should -Be $true
                $trustedHosts.Count | Should -Be 2
                $trustedHosts | Should -Be @('host1','host2')
            }

            $testCases = @(
                @{ Pattern = 'host'; Expected = @('host1','host2') }
                @{ Pattern = '1'; Expected = @('host1') }
            )

            It 'Get-TrustedHost with matching pattern returns correct hosts' -TestCases $testCases {
                param (
                    $Pattern,
                    $Expected
                )
                
                $trustedHosts = Get-TrustedHost -Pattern $Pattern
                    
                $trustedHosts.Count | Should -Be ($Expected).Count
                $trustedHosts | Should -Be $Expected
            }

            It 'Get-TrustedHost without matching pattern returns no hosts' {
                
                $trustedHosts = Get-TrustedHost -Pattern 3
                
                $trustedHosts | Should -be $null
            }
        }
    }
}
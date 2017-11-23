Get-Module psTrustedHosts | Remove-Module -Force
Import-Module $PSScriptRoot\..\psTrustedHosts -Force

InModuleScope psTrustedHosts {
    Describe 'Add-TrustedHost tests' {
        
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

        Context "Validate 'Computer' parameter" {

            $testCases = @(
                @{  Computers       = $null
                    Description     = 'null'
                    ErrorCount      = 1 }
                
                @{  Computers       = '' 
                    Description     = ''
                    ErrorCount      = 1 }
                
                @{  Computers       = ' ' 
                    Description     = ' '
                    ErrorCount      = 1 }
                
                @{  Computers       = "`t"
                    Description     = '`t'
                    ErrorCount      = 1 }
                
                @{  Computers       = "`n"
                    Description     = '`n'
                    ErrorCount      = 1 }
                
                @{  Computers       = @('',$null)
                    Description     = "@('',`$null)"
                    ErrorCount      = 2 }
                
                @{  Computers       = @('',$null,' ')
                    Description     = "@('',`$null,' ')"
                    ErrorCount      = 3 }
            )

            Context 'Add hosts via parameter' {
                It "Computer is `"<Description>`" writes error" -TestCases $testCases {
                    param (
                        $Computers,
                        $ErrorCount
                    )

                    $testErrors = $null
                    Add-TrustedHost -Computer $Computers -ErrorVariable testErrors -ErrorAction SilentlyContinue

                    $testErrors.Count | Should -BeExactly $ErrorCount
                    foreach ($e in $testErrors) {
                        $e | Should -BeExactly "'Computer' cannot be null, empty, or white space."
                    }
                    $testVariables.TrustedHostsString | Should -Be ''
                }
            }

            Context 'Add hosts via pipeline' {
                It "Computer is `"<Description>`" writes error (via pipeline)" -TestCases $testCases {
                    param (
                        $Computers,
                        $ErrorCount
                    )

                    $testErrors = $null
                    $Computers | Add-TrustedHost -ErrorVariable testErrors -ErrorAction SilentlyContinue

                    $testErrors.Count | Should -BeExactly $ErrorCount
                    foreach ($e in $testErrors) {
                        $e | Should -BeExactly "'Computer' cannot be null, empty, or white space."
                    }
                }
            }
        }

        Context 'Add hosts when no trusted hosts already exist' {
            BeforeEach {
                $testVariables.TrustedHostsString = ''
            }

            $testCases = @(
                @{  Computers   = @() 
                    Expected    = '' }
                @{  Computers   = 'host1' 
                    Expected    = 'host1' }
                @{  Computers   = @('host1','host2')
                    Expected    = 'host1,host2' }
                @{  Computers   = @('host1','host2','host1')
                    Expected    = 'host1,host2' }
            )

            # TODO:
            $testCasesWithInvalidComputers = @(
                @{  Computers   = @('host1','')
                    Expected    = 'host1' }
                @{  Computers   = @('host1','host2')
                    Expected    = 'host1,host2' }
                @{  Computers   = @('host1','host2','host1')
                    Expected    = 'host1,host2' }
            )

            Context 'Add hosts via parameter' {
                It "Add '<Computers>' via parameter results in '<Expected>'" -TestCases $testCases {
                    param (
                        $Computers,
                        $Expected)
                    
                    Add-TrustedHost -Computer $Computers
                    
                    $testVariables.TrustedHostsString | Should -Be $Expected
                }
            }

            Context 'Add hosts via pipeline' {
                It "Add '<Computers>' via pipeline results in '<Expected>'" -TestCases $testCases {
                    param (
                        $Computers,
                        $Expected)
                    
                    $Computers | Add-TrustedHost
                    
                    $testVariables.TrustedHostsString | Should -Be $Expected
                }
            }
        }

        Context 'Add hosts when single trusted host already exists' {
            BeforeEach {
                $testVariables.TrustedHostsString = 'existingHost1'
            }

            $testCases = @(
                @{  Computers   = @() 
                    Expected    = 'existingHost1' }
                @{  Computers   = 'host1' 
                    Expected    = 'existingHost1,host1' }
                @{  Computers   = @('host1','host2')
                    Expected    = 'existingHost1,host1,host2' }
                @{  Computers   = @('host1','host2','host1')
                    Expected    = 'existingHost1,host1,host2' }
                @{  Computers   = @('existingHost1')
                    Expected    = 'existingHost1' }
            )

            Context 'Add hosts via parameter' {
                It "Add '<Computers>' via parameter results in '<Expected>'" -TestCases $testCases {
                    param (
                        $Computers,
                        $Expected)
                    
                    Add-TrustedHost -Computer $Computers
                    
                    $testVariables.TrustedHostsString | Should -Be $Expected
                }
            }

            Context 'Add hosts via parameter' {
                It "Add '<Computers>' via pipeline results in '<Expected>'" -TestCases $testCases {
                    param (
                        $Computers,
                        $Expected)
                    
                    $Computers | Add-TrustedHost
                    
                    $testVariables.TrustedHostsString | Should -Be $Expected
                }
            }
        }

        Context 'Add hosts when multiple trusted hosts already exist' {
            BeforeEach {
                $testVariables.TrustedHostsString = 'existingHost1,existingHost2'
            }           

            $testCases = @(
                @{  Computers   = @() 
                    Expected    = 'existingHost1,existingHost2' }
                @{  Computers   = @('host1')
                    Expected    = 'existingHost1,existingHost2,host1' }
                @{  Computers   = @('host1','host2')
                    Expected    = 'existingHost1,existingHost2,host1,host2' }
                @{  Computers   = @('existingHost1')
                    Expected    = 'existingHost1,existingHost2' }
                @{  Computers   = @('existingHost1','host1')
                    Expected    = 'existingHost1,existingHost2,host1' }
            )

            Context 'Add hosts via parameter' {
                It "Add '<Computers>' via parameter results in '<Expected>'" -TestCases $testCases {
                    param (
                        $Computers, 
                        $Expected
                    )

                    Add-TrustedHost -Computer $Computers
                    $testVariables.TrustedHostsString | Should -Be $Expected
                }
            }

            Context 'Add hosts via pipeline' {
                It "Add '<Computers>' via pipeline results in '<Expected>'" -TestCases $testCases {
                    param (
                        $Computers, 
                        $Expected
                    )

                    $Computers | Add-TrustedHost
                    $testVariables.TrustedHostsString | Should -Be $Expected
                }
            }
        }
    }
}
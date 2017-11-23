Given "WSMan:\\localhost\\Client\\TrustedHosts initial state is '(?<State>.*)'" {
    param (
        $State
    )
    
    $testVariables.TrustedHostsString = $State
}

Then "WSMan:\\localhost\\Client\\TrustedHosts final state is '(?<State>.*)'" {
    param (
        $State
    )
    
    $testVariables.TrustedHostsString | Should -BeExactly $State
}

Then "(?<ErrorCount>0|[1-9]\d*) error\(s\) are written to the error stream" {
    param (
        [int]
        $ErrorCount
    )
    
    $testVariables.AddTrustedHostErrors.Count | Should -BeExactly $ErrorCount
}

Then "all errors are: 'Computer' cannot be null, empty, or white space\." {
    foreach ($e in $testVariables.AddTrustedHostErrors) {
        $e | Should -BeExactly "'Computer' cannot be null, empty, or white space."
    }
}
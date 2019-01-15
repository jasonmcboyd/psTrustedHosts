function GetMatchingTrustedHosts {
    param (
        [string]
        $Pattern
    )

    $trustedHosts = (Get-Item WSMan:\localhost\Client\TrustedHosts).Value
    
    if ($trustedHosts -eq '') {
        $result = @()
    }
    else {
        if ([String]::IsNullOrWhiteSpace($Pattern)) {
            $result = $trustedHosts.Split(',')
        }
        else {
            $result = $trustedHosts.Split(',') | Where-Object { $_ -like "$Pattern*" }
        }
    }

    $result `
    | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

Register-ArgumentCompleter -CommandName 'Get-TrustedHost', 'Computer' -ParameterName 'Pattern' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    GetMatchingTrustedHosts -Pattern $wordToComplete
}

Register-ArgumentCompleter -CommandName 'Remove-TrustedHost' -ParameterName 'Computer' -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    GetMatchingTrustedHosts -Pattern $wordToComplete
}
Feature: Get-TrustedHost

Scenario Outline: Invoke Get-TrustedHost
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: Get-TrustedHost, it yields <Expected>

    Scenarios: without 'Pattern' parameter
    | Initial        | Expected             |
    | ''             | @()                  |
    | 'host1'        | 'host1'              |
    | 'host1,host2'  | @('host1','host2')   |

Scenario Outline: Invoke Get-TrustedHost with pattern
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: Get-TrustedHost -Pattern <Pattern>, it yields <Expected>

    Scenarios: with 'Pattern' parameter
    | Initial           | Pattern    | Expected           |
    | ''                | host1      | @()                |
    | 'host1'           |  1         | 'host1'            |
    | 'host1,host2'     |  1         | 'host1'            |
    | 'host1,host2,h1'  |  host      | @('host1','host2') |
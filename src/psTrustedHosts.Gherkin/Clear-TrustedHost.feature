Feature: Clear-TrustedHost

Scenario Outline: Invoke Clear-TrustedHost
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: Clear-TrustedHost
    Then WSMan:\localhost\Client\TrustedHosts final state is <Final>

    Scenarios: no existing hosts and invalid args
    | Initial        | Final         |
    | ''             | ''            |
    | 'host1'        | ''            |
    | 'host1,host2'  | ''            |
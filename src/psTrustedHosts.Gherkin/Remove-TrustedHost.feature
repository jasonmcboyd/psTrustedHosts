Feature: Remove-TrustedHost

Scenario Outline: Invoke Remove-TrustedHost and pass arguments via the 'Computer' parameter
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: Remove-TrustedHost -Computer <Computer>
    Then WSMan:\localhost\Client\TrustedHosts final state is <Final>

    Scenarios: no existing hosts
    | Initial        | Computer        | Final     |
    | ''             | ''              | ''        |
    | ''             | 'host'          | ''        |
    | ''             | 'host1','host2' | ''        |

    Scenarios: existing hosts
    | Initial             | Computer        | Final     |
    | 'host1'             | ''              | 'host1'   |
    | 'host1'             | 'host1'         | ''        |
    | 'host1'             | 'host1','host2' | ''        |
    | 'host1,host2'       | 'host1','host2' | ''        |
    | 'host1,host2,host3' | 'host1','host2' | 'host3'   |

Scenario Outline: Invoke Remove-TrustedHost and pass arguments via the pipeline
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: <Computer> | Remove-TrustedHost
    Then WSMan:\localhost\Client\TrustedHosts final state is <Final>

    Scenarios: no existing hosts
    | Initial        | Computer        | Final     |
    | ''             | ''              | ''        |
    | ''             | 'host'          | ''        |
    | ''             | 'host1','host2' | ''        |

    Scenarios: existing hosts
    | Initial             | Computer        | Final     |
    | 'host1'             | ''              | 'host1'   |
    | 'host1'             | 'host1'         | ''        |
    | 'host1'             | 'host1','host2' | ''        |
    | 'host1,host2'       | 'host1','host2' | ''        |
    | 'host1,host2,host3' | 'host1','host2' | 'host3'   |
Feature: Add-TrustedHost

Scenario Outline: Invoke Add-TrustedHost and pass arguments via the 'Computer' parameter
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: Add-TrustedHost -Computer <Computer>
    Then WSMan:\localhost\Client\TrustedHosts final state is <Final>
    And <ErrorCount> error(s) are written to the error stream
    And all errors are: 'Computer' cannot be null, empty, or white space.

    Scenarios: no existing hosts and invalid args
    | Initial        | Computer        | Final         | ErrorCount |
    | ''             | ''              | ''            | 1          |
    | ''             | ' '             | ''            | 1          |
    | ''             | '`t'            | ''            | 1          |
    | ''             | '`n'            | ''            | 1          |
    | ''             | '','`t'         | ''            | 2          |

    Scenarios: existing hosts and invalid args
    | Initial        | Computer        | Final         | ErrorCount |
    | 'host1'        | ''              | 'host1'       | 1          |
    | 'host1'        | ' '             | 'host1'       | 1          |
    | 'host1'        | '`t'            | 'host1'       | 1          |
    | 'host1'        | '`n'            | 'host1'       | 1          |
    | 'host1'        | '','`t'         | 'host1'       | 2          |
    
    Scenarios: no existing host and valid args
    | Initial        | Computer        | Final         | ErrorCount |
    | ''             | 'host1'         | 'host1'       | 0          |
    | ''             | 'host1','host2' | 'host1,host2' | 0          |

    Scenarios: existing host and valid args
    | Initial        | Computer        | Final                     | ErrorCount |
    | 'host1'        | 'host2'         | 'host1,host2'             | 0          |
    | 'host1'        | 'host2','host3' | 'host1,host2,host3'       | 0          |
    | 'host1,host2'  | 'host3'         | 'host1,host2,host3'       | 0          |
    | 'host1,host2'  | 'host3','host4' | 'host1,host2,host3,host4' | 0          |

    Scenarios: no existing host and mix of valid and invalid args
    | Initial        | Computer                | Final         | ErrorCount |
    | ''             | '','host1'              | 'host1'       | 1          |
    | ''             | '','host1','host2'      | 'host1,host2' | 1          |
    | ''             | '','host1','`t'         | 'host1'       | 2          |
    | ''             | '','host1','`t','host2' | 'host1,host2' | 2          |

    Scenarios: existing host and mix of valid and invalid args
    | Initial        | Computer                | Final                     | ErrorCount |
    | 'host1'        | '','host2'              | 'host1,host2'             | 1          |
    | 'host1'        | '','host2','host3'      | 'host1,host2,host3'       | 1          |
    | 'host1,host2'  | '','host3','`t'         | 'host1,host2,host3'       | 2          |
    | 'host1,host2'  | '','host3','`t','host4' | 'host1,host2,host3,host4' | 2          |

Scenario Outline: Invoke Add-TrustedHost and pass arguments via the pipeline
    Given WSMan:\localhost\Client\TrustedHosts initial state is <Initial>
    When we invoke: <Computer> | Add-TrustedHost
    Then WSMan:\localhost\Client\TrustedHosts final state is <Final>
    And <ErrorCount> error(s) are written to the error stream
    And all errors are: 'Computer' cannot be null, empty, or white space.

    Scenarios: no existing hosts and invalid args
    | Initial        | Computer        | Final         | ErrorCount |
    | ''             | ''              | ''            | 1          |
    | ''             | ' '             | ''            | 1          |
    | ''             | '`t'            | ''            | 1          |
    | ''             | '`n'            | ''            | 1          |
    | ''             | '','`t'         | ''            | 2          |

    Scenarios: existing hosts and invalid args
    | Initial        | Computer        | Final         | ErrorCount |
    | 'host1'        | ''              | 'host1'       | 1          |
    | 'host1'        | ' '             | 'host1'       | 1          |
    | 'host1'        | '`t'            | 'host1'       | 1          |
    | 'host1'        | '`n'            | 'host1'       | 1          |
    | 'host1'        | '','`t'         | 'host1'       | 2          |
    
    Scenarios: no existing host and valid args
    | Initial        | Computer        | Final         | ErrorCount |
    | ''             | 'host1'         | 'host1'       | 0          |
    | ''             | 'host1','host2' | 'host1,host2' | 0          |

    Scenarios: existing host and valid args
    | Initial        | Computer        | Final                     | ErrorCount |
    | 'host1'        | 'host2'         | 'host1,host2'             | 0          |
    | 'host1'        | 'host2','host3' | 'host1,host2,host3'       | 0          |
    | 'host1,host2'  | 'host3'         | 'host1,host2,host3'       | 0          |
    | 'host1,host2'  | 'host3','host4' | 'host1,host2,host3,host4' | 0          |

    Scenarios: no existing host and mix of valid and invalid args
    | Initial        | Computer                | Final         | ErrorCount |
    | ''             | '','host1'              | 'host1'       | 1          |
    | ''             | '','host1','host2'      | 'host1,host2' | 1          |
    | ''             | '','host1','`t'         | 'host1'       | 2          |
    | ''             | '','host1','`t','host2' | 'host1,host2' | 2          |

    Scenarios: existing host and mix of valid and invalid args
    | Initial        | Computer                | Final                     | ErrorCount |
    | 'host1'        | '','host2'              | 'host1,host2'             | 1          |
    | 'host1'        | '','host2','host3'      | 'host1,host2,host3'       | 1          |
    | 'host1,host2'  | '','host3','`t'         | 'host1,host2,host3'       | 2          |
    | 'host1,host2'  | '','host3','`t','host4' | 'host1,host2,host3,host4' | 2          |
Feature: output file for metrics tool

  Scenario: passing output file in the command line
    Given I am in .
    When I run "analizo metrics --output output t/samples/sample_basic/"
    Then the contents of "output.yml" must match "module2"
    And the exit status must be 0

  Scenario: passing output file without permission to write
    Given I am in .
    When I run "touch output2.yml"
    And I run "chmod 000 output2.yml"
    And I run "analizo metrics --output output2 t/samples/sample_basic/"
    Then the exit status must not be 0
    And analizo must emit a warning matching "Permission denied"

  Scenario: passing output file in an unexisting directory
    Given I am in .
    When I run "analizo metrics --output /this/directory/must/not/exists/output.yml t/samples"
    Then the exit status must not be 0
    And analizo must emit a warning matching "No such file or directory"

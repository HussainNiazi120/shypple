Feature: Shypple CLI

  Scenario: User searches for the cheapest direct route
    Given I run the Shypple CLI
    When I input "CNSHA"
    And I input "NLRTM"
    And I input "cheapest-direct"
    Then I should see '[{"origin_port":"CNSHA","destination_port":"NLRTM","departure_date":"2024-09-03","arrival_date":"2024-10-06","sailing_code":"MNOP","rate":"456.78","rate_currency":"USD"}]'

  Scenario: User searches for the cheapest route
    Given I run the Shypple CLI
    When I input "CNSHA"
    And I input "NLRTM"
    And I input "cheapest"
    Then I should see '[{"origin_port":"CNSHA","destination_port":"ESBCN","departure_date":"2024-09-02","arrival_date":"2024-09-15","sailing_code":"ERXQ","rate":"261.96","rate_currency":"EUR"},{"origin_port":"ESBCN","destination_port":"NLRTM","departure_date":"2024-09-19","arrival_date":"2024-09-23","sailing_code":"ETRG","rate":"69.96","rate_currency":"USD"}]'

  Scenario: User searches for the fastest route
    Given I run the Shypple CLI
    When I input "CNSHA"
    And I input "NLRTM"
    And I input "fastest"
    Then I should see '[{"origin_port":"CNSHA","destination_port":"NLRTM","departure_date":"2024-09-02","arrival_date":"2024-09-18","sailing_code":"QRST","rate":"761.96","rate_currency":"EUR"}]'
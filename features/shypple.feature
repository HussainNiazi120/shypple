Feature: Shypple CLI

  Scenario: User searches for the cheapest direct route
    Given I run the Shypple CLI
    When I input "CNSHA"
    And I input "NLRTM"
    And I input "cheapest-direct"
    Then I should see the following keywords:
      | "origin_port":"CNSHA" |
      | "destination_port":"NLRTM" |
      | "departure_date":  |
      | "arrival_date" |
      | "sailing_code":"MNOP" |
      | "rate":"456.78" |
      | "rate_currency":"USD" |
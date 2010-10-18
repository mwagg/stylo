Feature: Javascript serving

  Scenario: Simple javascript serving
    Given "child.js" is located at "javascripts" in the asset location
    When a request is made for "javascripts/child.js"
    Then the response body should look like "child.js"

  Scenario: Simple javascript combining
    Given "parent.js" is located at "javascripts" in the asset location
    And "child.js" is located at "javascripts" in the asset location
    And javascript combining is disabled
    When a request is made for "javascripts/parent.js"
    Then the response body should look like "parent.js"

  Scenario: Simple javascript combining
    Given "parent.js" is located at "javascripts" in the asset location
    And "child.js" is located at "javascripts" in the asset location
    When a request is made for "javascripts/parent.js"
    Then the response body should look like "parent_with_child.js"

  Scenario: Nested stylesheet combining
    Given "grand_parent.js" is located at "javascripts" in the asset location
    And "parent.js" is located at "javascripts" in the asset location
    And "child.js" is located at "javascripts" in the asset location
    When a request is made for "javascripts/grand_parent.js"
    Then the response body should look like "grand_parent_with_parent_with_child.js"

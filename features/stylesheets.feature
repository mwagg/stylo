Feature: Stylesheet serving

  Scenario: Simple stylesheet serving
    Given "child.css" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/child.css"
    Then the response body should look like "child.css"

  Scenario: Simple stylesheet combining
    Given "parent.css" is located at "stylesheets" in the asset location
    And "child.css" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/parent.css"
    Then the response body should look like "parent_with_child.css"

  Scenario: Nested stylesheet combining
    Given "grand_parent.css" is located at "stylesheets" in the asset location
    And "parent.css" is located at "stylesheets" in the asset location
    And "child.css" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/grand_parent.css"
    Then the response body should look like "grand_parent_with_parent_with_child.css"

Feature: Stylesheet serving

  Scenario: Simple stylesheet serving
    Given "child.css" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/child.css"
    Then the response body should look like "child.css"

  Scenario: Combining does not take place when it is disabled
    Given "parent.css" is located at "stylesheets" in the asset location
    And "child.css" is located at "stylesheets" in the asset location
    And css combining is disabled
    When a request is made for "stylesheets/parent.css"
    Then the response body should look like "parent.css"

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

  Scenario: Stylesheet responses should have the correct headers
    Given "child.css" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/child.css"
    Then the response code should be "200"
    And the "Content-Length" header should be "35"
    And the "Content-Type" header should be "text/css"

  Scenario: Stylesheets should be cached
    Given "child.css" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/child.css"
    Then the "Cache-Control" header should be "public, max-age=86400"
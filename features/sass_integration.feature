Feature: Sass integration

  Scenario: Simple sass stylesheet serving
    Given Sass integration is enabled
    And "sass_child.scss" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/sass_child.css"
    Then the response body should look like "processed_sass_child.css"
Feature: Sass integration

  Scenario: Simple sass stylesheet serving
    Given "sass_child.scss" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/sass_child.css"
    Then the response body should look like "processed_sass_child.css"

  Scenario: Combined sass stylesheet serving
    Given "sass_mixins.scss" is located at "stylesheets" in the asset location
    And "sass_which_uses_mixin.scss" is located at "stylesheets" in the asset location
    When a request is made for "stylesheets/sass_which_uses_mixin.css"
    Then the response body should look like "processed_sass_which_uses_mixin.css"


Feature: Response headers

  Scenario: Responses should have the correct headers
    Given "child.js" is located at "javascripts" in the asset location
    When a request is made for "javascripts/child.js"
    Then the response code should be "200"
    And the "Content-Length" header should be "40"
    And the "Content-Type" header should be "text/javascript"

  Scenario: Content should be cached
    Given "child.js" is located at "javascripts" in the asset location
    When a request is made for "javascripts/child.js"
    Then the "Cache-Control" header should be "public, max-age=86400"
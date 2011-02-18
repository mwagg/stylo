Feature: Stylo cannot serve an asset

  Scenario: Stylo returns a 404 response
    When a request is made for "javascripts/i-dont-exist.js"
    Then the response should be a 404

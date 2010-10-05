Feature: Stylo cannot serve an asset

  Scenario: Stylo calls back into rack
    When a request is made for "javascripts/i-dont-exist.js"
    Then the response should be from a call back into rack
Given /^"([^"]*)" is located at "([^"]*)" in the asset location$/ do |filename, folder|
  cp fixture_path(filename), temp_path(folder)
end

When /^a request is made for "([^"]*)"$/ do |path|
  get path
end

Then /^the response body should look like "([^"]*)"$/ do |filename|
  last_response.body.should == load_fixture(filename)
end

Then /^the response code should be "([^\"]*)"$/ do |response_code|
  last_response.status.should == response_code.to_i
end

When /^the "([^\"]*)" header should be "([^\"]*)"$/ do |header_key, expected_value|
  last_response.headers[header_key].should == expected_value
end

Given /^Sass integration is enabled$/ do
  Stylo::Config.enable_sass = true
end
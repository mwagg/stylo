Given /^"([^"]*)" is located at "([^"]*)" in the asset location$/ do |filename, folder|
  cp fixture_path(filename), temp_path(folder)
end

Given /^a folder "([^"]*)" exists at "([^"]*)" in the asset location$/ do |folder_name, folder|
  mkdir temp_path("#{folder}/#{folder_name}")
end


When /^a request is made for "([^"]*)"$/ do |path|
  get path
end

When /^a request is made for "([^"]*)" the following error should be raised$/ do |path, expected_error|
  proc { get path }.should raise_error(expected_error)
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

Then /^the response should be a (\d+)$/ do |expected_status_code|
  last_response.status.to_s.should == expected_status_code
end

When /^javascript combining is disabled$/ do
  Stylo::Config.options[:js_combining_enabled] = false
end

When /^css combining is disabled$/ do
  Stylo::Config.options[:css_combining_enabled] = false
end

Given /^javascript minifying is disabled$/ do
  Stylo::Config.options[:js_minifying_enabled] = false
end

Given /^javascript minifying is enabled$/ do
  Stylo::Config.options[:js_minifying_enabled] = true
end

Given /^css minifying is enabled$/ do
  Stylo::Config.options[:css_minifying_enabled] = true
end

Given /^css minifying is disabled$/ do
  Stylo::Config.options[:css_minifying_enabled] = false
end

Given /^"([^"]*)" is excluded from css minifying$/ do |stylesheet_file|
  Stylo::Config.options[:css_minifying_exclusions] = [stylesheet_file]
end

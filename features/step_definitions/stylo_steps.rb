Given /^"([^"]*)" is located at "([^"]*)" in the asset location$/ do |filename, folder|
  cp fixture_path(filename), temp_path(folder)
end

When /^a request is made for "([^"]*)"$/ do |path|
  get path
end

Then /^the response body should look like "([^"]*)"$/ do |filename|
  last_response.body.should == load_fixture(filename)
end
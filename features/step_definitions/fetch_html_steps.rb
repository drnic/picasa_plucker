Given /^I expect to fetch "([^\"]*)" but use "([^\"]*)"$/ do |url, fixture|
  body = File.read(File.join(File.dirname(__FILE__) + "/../fixtures/", fixture))
  FakeWeb.register_uri(:get, url, :body => body)
end


module Fixtures
  def load_fixture(fixture_name)
    File.read File.join(File.dirname(__FILE__), 'fixtures', fixture_name)
  end
end
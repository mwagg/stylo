module StyloSpecHelpers
  def temp_path(path = '')
    File.expand_path(File.join(File.dirname(__FILE__), '../tmp', path))
  end

  def fixture_path(path)
    File.expand_path(File.join(File.dirname(__FILE__), '../features/fixtures', path))
  end

  def load_fixture(path)
    File.read fixture_path(path)
  end

  def write_content(path, content)
    File.open(path, 'w') do |f|
      f.write(content)
    end
  end

  def reset_paths
    @stylesheets_path = temp_path('stylesheets')
    @javascripts_path = temp_path('javascripts')
    [@stylesheets_path, @javascripts_path].each do |path|
      rm_rf path
      mkdir_p path
    end

    Stylo::Config.options[:asset_location] = temp_path()
  end
end
module Stylo
  class AssetLoader
    def self.load_content(path)
      path = File.join(Stylo::Config.asset_location, path)

      File.read(path) if File.exist?(path)
    end
  end
end
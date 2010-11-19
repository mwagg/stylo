require 'rubygems'
require 'rake'
require 'cucumber'
require 'cucumber/rake/task'
require 'bundler'

Bundler::GemHelper.install_tasks

#begin
#  require 'jeweler'
#  Jeweler::Tasks.new do |gem|
#    gem.name = "stylo"
#    gem.summary = %Q{Server side stylesheet combining for readonly hosting environments}
#    gem.description = %Q{Server side stylesheet combining for readonly hosting environments}
#    gem.email = "michael@guerillatactics.co.uk"
#    gem.homepage = "http://github.com/mwagg/stylo"
#    gem.authors = ["mwagg"]
#    gem.add_development_dependency "rspec", ">= 0"
#    gem.add_development_dependency "cucumber", ">= 0"
#    gem.add_development_dependency "rack-test", ">= 0"
#    gem.add_development_dependency "sinatra", ">= 0"
#    gem.add_development_dependency "rails", ">= 3.0.0"
#    gem.add_runtime_dependency "haml", ">= 3.0.21"
#    gem.version = "0.7.0"
#    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
#  end
#  Jeweler::GemcutterTasks.new
#rescue LoadError
#  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
#end

require 'rspec/core/rake_task'
desc "Run all examples"
RSpec::Core::RakeTask.new()

task :default => [:spec, :features]

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "stylo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Cucumber::Rake::Task.new(:features) do |t|
  t.profile = :default
end

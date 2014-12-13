require 'rake/testtask'
require './lib/set_env/version'

task :uninstall do
  puts 'Unintalling..'
  `gem uninstall setenv -ax`
  `rbenv rehash`
end

task :install => :uninstall  do
  `rm *.gem`
  `gem build setenv.gemspec`
  `gem install --local setenv-#{SetEnv::VERSION}.gem`
  `rbenv rehash`
end
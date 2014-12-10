require 'rake/testtask'
require './lib/veda/version'

Rake::TestTask.new do |t|
	t.libs << "lib/veda.rb"
	t.test_files = FileList['test/*_test.rb']
	t.verbose = true
end

task :zip do
  `cd test && rm -f test-repo.zip && zip -r test-repo.zip test-repo && rm -rf test-repo`
end

task :unzip do
  `cd test && unzip test-repo.zip`
end

task :uninstall do
  puts 'Unintalling..'
  `gem uninstall veda -ax`
  `rbenv rehash`
end

task :install => :uninstall  do
  `rm *.gem`
  `gem build veda.gemspec`
  `gem install --local veda-#{Veda::VERSION}.gem`
  `rbenv rehash`
end

task :default => :test
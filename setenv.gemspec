require './lib/set_env/version'

Gem::Specification.new do |s|
  s.name        = 'setenv'
  s.version     = SetEnv::VERSION
  s.date        = '2014-12-10'
  s.summary     = "SetEnv"
  s.description = "Wrangle heroku env with pleasure"
  s.authors     = ["Emile Bosch"]
  s.email       = 'emilebosch@me.com'
  s.files        = Dir.glob('{lib}/**/*') + %w(README.md setenv.gemspec Gemfile)
  s.homepage    = 'https://github.com/emilebosch/heroku-env'
  s.license     = 'MIT'
  s.executables << 'setenv'

  s.add_dependency 'thor'
  s.add_dependency 'bundler'
  s.add_dependency 'hashdiff'

  s.add_development_dependency 'rake'
end
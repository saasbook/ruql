Gem::Specification.new do |s|
  s.name        = 'ruql'
  s.version     = '0.1.6'
  s.date        = '2016-11-10'
  s.summary     = "Ruby question language"
  s.description = "Ruby-embedded DSL for creating short-answer quiz questions"
  s.authors     = ["Armando Fox"]
  s.email       = 'fox@cs.berkeley.edu'
  s.files = []
  s.files       << 'lib/ruql.rb'
  s.files +=  %w(answer dropdown fill_in multiple_choice question quiz renderer select_multiple tex_output true_false).
    map { |s| "lib/ruql/#{s}.rb" }
  s.files += Dir["lib/ruql/open_assessment/*.rb"]
  s.files += Dir["lib/ruql/renderers/*.rb"]
  # add the templates
  s.files += Dir["templates/*.erb"]
  s.executables << 'ruql'
  # dependencies
  s.add_runtime_dependency 'builder', '>= 3.0'
  s.add_runtime_dependency 'getopt', '>= 1.0'
  s.add_development_dependency 'rspec', '>= 2.0'
  s.add_development_dependency 'activesupport', '~> 4.0'
  s.homepage    = 'http://github.com/saasbook/ruql'
  s.license       = 'MIT'
end

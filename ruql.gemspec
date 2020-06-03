lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ruql/version'

Gem::Specification.new do |s|
  s.name        = 'ruql'
  s.version     = Ruql::VERSION
  s.summary     = "Ruby question language"
  s.description = "Ruby-embedded DSL for creating short-answer quiz questions"
  s.authors     = ["Armando Fox"]
  s.email       = 'fox@berkeley.edu'
  s.require_paths= ['lib']
  s.files = []
  s.files       << 'lib/ruql.rb'
  s.files +=  %w(version quiz answer dropdown fill_in multiple_choice
                     question quiz renderer stats
                     select_multiple tex_output true_false).
    map { |s| "lib/ruql/#{s}.rb" }
  s.files += %w(criterion open_assessment option training training_criterion).
    map { |s| "lib/ruql/open_assessment/#{s}.rb" }
  s.executables << 'ruql'
  # dependencies
  s.homepage    = 'http://github.com/saasbook/ruql'
  s.license       = 'CC By-SA'

  s.add_development_dependency "byebug"
  s.add_development_dependency "bundler", "~> 1.17"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"

end

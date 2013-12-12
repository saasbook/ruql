Gem::Specification.new do |s|
  s.name        = 'ruql'
  s.version     = '0.0.1'
  s.date        = '2013-12-15'
  s.summary     = "Ruby question language"
  s.description = "Ruby-embedded DSL for creating short-answer quiz questions"
  s.authors     = ["Armando Fox"]
  s.email       = 'fox@cs.berkeley.edu'
  s.files       = %w(ruql
                     answer question renderer
                     select_multiple fill_in multiple_choice true_false
                     tex_output 
                     auto_qcm_renderer edxml_renderer html5_renderer
                     json_renderer xml_renderer).map { |s| "lib/#{s}.rb" }
  # add the templates
  s.files += Dir["templates/*.erb"]
  s.executables << 'ruql'
  # dependencies
  s.add_runtime_dependency 'builder'
  s.homepage    = 'http://rubygems.org/gems/ruql'
  s.license       = 'BSD'
end

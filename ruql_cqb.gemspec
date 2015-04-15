Gem::Specification.new do |s|
<<<<<<< 8eb097be95901153af22ab5f86dbd790f9243901
  s.name        = 'ruql'
  s.version     = '0.0.8'
  s.date        = '2016-02-13'
=======
  s.name        = 'ruql_cqb'
  s.version     = '0.0.3'
  s.date        = '2015-04-14'
>>>>>>> temp
  s.summary     = "Ruby question language"
  s.description = "Ruby-embedded DSL for creating short-answer quiz questions"
  s.authors     = ["Armando Fox", "Aaron Zhang", "Jesmin Ngo"]
  s.email       = 'xjesminngo@berkeley.edu'
  s.files = []
  s.files       << 'lib/ruql.rb'
  s.files +=  %w(quiz answer dropdown fill_in multiple_choice
                     question quiz renderer
                     select_multiple tex_output true_false).
    map { |s| "lib/ruql/#{s}.rb" }
  s.files += %w(criterion open_assessment option training training_criterion).
    map { |s| "lib/ruql/open_assessment/#{s}.rb" }
  s.files += %w(auto_qcm_renderer edxml_renderer html5_renderer html_form_renderer
                     json_renderer qualtrics_renderer xml_renderer).
    map { |s| "lib/ruql/renderers/#{s}.rb" }
  # add the templates
  s.files += Dir["templates/*.erb"]
  s.executables << 'ruql_cqb'
  # dependencies
  s.add_runtime_dependency 'builder', '~> 3.0'
  s.add_runtime_dependency 'getopt', '1.4.2'
  s.homepage    = 'http://github.com/saasbook/ruql'
  s.license       = 'CC By-SA'
end

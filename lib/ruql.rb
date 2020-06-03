# basic gems/libs we rely on
require 'builder'
require 'logger'
require 'date'

require 'ruql/version'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__)))

module Ruql
  class OptionsError < StandardError ;  end
  class QuizContentError < StandardError ;  end
end

# question types
require 'ruql/quiz'
require 'ruql/question'
require 'ruql/answer'
require 'ruql/multiple_choice'
require 'ruql/select_multiple'
require 'ruql/true_false'
require 'ruql/fill_in'
require 'ruql/dropdown'
require 'ruql/open_assessment/open_assessment'
require 'ruql/open_assessment/criterion'
require 'ruql/open_assessment/option'
require 'ruql/open_assessment/training'
require 'ruql/open_assessment/training_criterion'
require 'ruql/stats'

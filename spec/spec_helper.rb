require 'byebug'
require 'bundler/setup'
Bundler.setup

require 'ruql'

RSpec.configure do |config|
  require File.join(File.dirname(__FILE__), 'support/matchers/xml_matcher.rb')
end

# Dir[File.join(File.dirname(__FILE__), '..', 'lib', '*.rb')].each { |f|  load f }
# Dir[File.join(File.dirname(__FILE__), '/support', '**', '*.rb')].each {|f| load f}

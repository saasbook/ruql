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
  s.homepage    = 'http://github.com/saasbook/ruql'
  s.license       = 'CC By-SA'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata["allowed_push_host"] = "https://rubygems.org"

    s.metadata["homepage_uri"] = s.homepage
    s.metadata["source_code_uri"] = s.homepage
    #s.metadata["changelog_uri"] = ''
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.executables << 'ruql'

  s.require_paths= ['lib']

  s.add_development_dependency "bundler", "~> 1.17"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec_its"
end

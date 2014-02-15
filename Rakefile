task :default => :ruql

task :ruql do
  sh "ruql examples/example.rb HtmlForm > examples/file.html"
end

task :install do
  sh "gem build ruql.gemspec"
  sh "sudo gem install ./ruql-0.0.2.gem"
end

task :uninstall do
  sh "sudo gem uninstall ruql"
end

task :default => :ruql

task :ruql do
  sh "ruql examples/example.rb HtmlForm > examples/file.html"
end

task :js do
  sh "ruql examples/example.rb HtmlForm -j prueba.js > examples/file.html"
end

task :css do
  sh "ruql examples/example.rb HtmlForm -c estilo.css > examples/file.html"
end

task :install do
  sh "gem build ruql.gemspec"
  sh "sudo gem install ./ruql-0.0.2.gem"
end

task :rvm do
  sh "gem build ruql.gemspec"
  sh "gem install ./ruql-0.0.2.gem"
end

task :uninstall do
  sh "sudo gem uninstall ruql"
end

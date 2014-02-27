task :default => :ruql

desc "Run Ruql with HtmlForm renderer"
task :ruql do
  sh "ruby -Ilib bin/ruql examples/example.rb HtmlForm > examples/file.html"
end

desc "Run Ruql with HtmlForm renderer and JavaScript"
task :js do
  sh "ruby -Ilib bin/ruql examples/example.rb HtmlForm -j prueba.js > examples/file.html"
end

desc "Run Ruql with HtmlForm renderer and CSS"
task :css do
  sh "ruby -Ilib bin/ruql examples/example.rb HtmlForm -c estilo.css > examples/file.html"
end

desc "Install Ruql using RVM"
task :rvm do
  sh "gem build ruql.gemspec"
  sh "gem install ./ruql-0.0.2.gem"
end

desc "Uninstall Ruql"
task :uninstall do
  sh "gem uninstall ruql"
end

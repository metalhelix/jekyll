require 'rubygems'
require 'rake'
require 'date'

require 'bundler/gem_tasks'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

task :default => [:test, :features]

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  if `which pygmentize` == ''
    puts "You must have Pygments installed to run the tests."
    exit 1
  end
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Generate RCov test coverage and open in your browser"
task :coverage do
  require 'rcov'
  sh "rm -fr coverage"
  sh "rcov test/test_*.rb"
  sh "open coverage/index.html"
end


desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Custom tasks (add your own tasks here)
#
#############################################################################

namespace :migrate do
  desc "Migrate from mephisto in the current directory"
  task :mephisto do
    sh %q(ruby -r './lib/jekyll/migrators/mephisto' -e 'Jekyll::Mephisto.postgres(:database => "#{ENV["DB"]}")')
  end
  desc "Migrate from Movable Type in the current directory"
  task :mt do
    sh %q(ruby -r './lib/jekyll/migrators/mt' -e 'Jekyll::MT.process("#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")')
  end
  desc "Migrate from Typo in the current directory"
  task :typo do
    sh %q(ruby -r './lib/jekyll/migrators/typo' -e 'Jekyll::Typo.process("#{ENV["DB"]}", "#{ENV["USER"]}", "#{ENV["PASS"]}")')
  end
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "--format progress"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end


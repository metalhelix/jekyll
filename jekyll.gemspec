require File.expand_path('../lib/jekyll/version', __FILE__)

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'jekyll'
  s.version           = Jekyll::VERSION.dup
  s.date              = '2011-11-26'
  s.rubyforge_project = 'jekyll'

  s.summary     = "A simple, blog aware, static site generator."
  s.description = "Jekyll is a simple, blog aware, static site generator."

  s.authors  = ["Tom Preston-Werner"]
  s.email    = 'tom@mojombo.com'
  s.homepage = 'http://github.com/mojombo/jekyll'

  s.require_paths = %w[lib]

  s.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.textile LICENSE]

  s.add_runtime_dependency('liquid', "~> 2.3")
  s.add_runtime_dependency('classifier', "~> 1.3")
  s.add_runtime_dependency('directory_watcher', "~> 1.1")
  s.add_runtime_dependency('maruku', "~> 0.5")
  s.add_runtime_dependency('kramdown', "~> 0.13")
  s.add_runtime_dependency('albino', "~> 1.3")

  s.add_development_dependency('rake', "~> 0.9.2")
  s.add_development_dependency('rdoc', "~> 3.11")
  s.add_development_dependency('redgreen', "~> 1.2")
  s.add_development_dependency('shoulda', "~> 2.11")
  s.add_development_dependency('rr', "~> 1.0")
  s.add_development_dependency('cucumber', "= 1.1")
  s.add_development_dependency('RedCloth', "~> 4.2")
  s.add_development_dependency('rdiscount', "~> 1.6")
  s.add_development_dependency('redcarpet', "~> 2.0")
  s.add_development_dependency('test-unit', "~> 1.2.3")
  s.add_development_dependency('bundler', "~> 1.0")
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

end

require 'rake'

SPEC = Gem::Specification.new do |s|
  s.name = "more"
  s.summary = "LESS on Rails"
  s.homepage = "http://github.com/cloudhead/more"
  s.description = <<-EOS
    More is a plugin for Ruby on Rails applications. It automatically
    parses your applications .less files through LESS and outputs CSS files.
  EOS
  s.authors = ["August Lilleaas", "Logan Raarup"]
  s.version = "0.1.0"
  s.files = FileList["README.markdown", "MIT-LICENSE", "Rakefile", "init.rb", "lib/*.rb", "rails/init.rb", "tasks/*", "test/*"]
  s.has_rdoc = true

  s.date = '2011-06-10'

  s.extra_rdoc_files = [
                        "MIT-LICENSE",
                        "README.markdown"
                       ]

  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<actionpack>, ["~> 2.3.8"])
      s.add_development_dependency(%q<activesupport>, ["~> 2.3.8"])
      s.add_development_dependency(%q<rails>, ["~> 2.3.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<less>, ["~> 1.2.21"])
      s.add_runtime_dependency(%q<more>, [">= 0"])
    else
      s.add_dependency(%q<actionpack>, ["~> 2.3.8"])
      s.add_dependency(%q<activesupport>, ["~> 2.3.8"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<less>, ["~> 1.2.21"])
      s.add_dependency(%q<more>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 2.3.8"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<actionpack>, ["~> 2.3.8"])
    s.add_dependency(%q<activesupport>, ["~> 2.3.8"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<less>, ["~> 1.2.21"])
    s.add_dependency(%q<more>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 2.3.8"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name             = 'more'

    gemspec.summary          = 'LESS on Rails'
    gemspec.description      =
      'More is a plugin for Ruby on Rails applications. It automatically ' \
      'parses your applications .less files through LESS and outputs CSS.'

    gemspec.authors          = ['August Lilleaas', 'Logan Raarup']
    gemspec.homepage         = 'http://github.com/cloudhead/more'

    gemspec.files            = FileList[*%w(Rakefile init.rb lib/**/*.{rb,rake} rails/init.rb tasks/* test/*)]
    gemspec.extra_rdoc_files = %w( README.markdown MIT-LICENSE )
    gemspec.has_rdoc         = true

    gemspec.version          = '0.1.2'
    gemspec.require_path     = 'lib'

    gemspec.add_dependency 'less'
  end
rescue LoadError
  puts 'Jeweler not available. Install it with: gem install jeweler'
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the more plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the more plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'More'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.markdown')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

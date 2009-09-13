require 'less'
require File.join(File.dirname(__FILE__), '..', 'lib', 'more')

namespace :more do
  desc "Generate CSS files from LESS files"
  task :parse => :environment do
    files = Less::More.parse
    
    puts "Successfully parsed files:"

    files.each do |f|
      puts "  - " + f[:source].relative_path_from(Less::More.source_path).to_s
    end
    
    puts "\nSaved to: " + Less::More.destination_path.to_s
  end
  
  desc "Remove generated CSS files"
  task :clean => :environment do
    files = Less::More.map
    
    puts "Deleting files:"

    files.each do |f|
      if f[:destination].exist?
        puts "  - " + f[:destination]
        f[:destination].delete
      
        if f[:destination].parent.children.empty? and f[:destination].parent != Less::More.destination_path
          puts "  - " + f[:destination].parent
          f[:destination].parent.delete
        end
      end
    end
  end
end
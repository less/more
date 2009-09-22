require 'less'
require File.join(File.dirname(__FILE__), '..', 'lib', 'more')

namespace :more do
  desc "Generate CSS files from LESS files"
  task :parse => :environment do
    puts "Parsing files from #{Less::More.source_path}."
    puts

    Less::More.all_less_files.each do |path|
      # Get path
      relative_path = path.relative_path_from(Less::More.source_path)
      path_as_array = relative_path.to_s.split(File::SEPARATOR)
      path_as_array[-1] = File.basename(path_as_array[-1], File.extname(path_as_array[-1]))
      
      # Generate CSS
      css = Less::More.generate(path_as_array)
      
      # Store CSS
      path_as_array[-1] = path_as_array[-1] + ".css"
      destination = Pathname.new(File.join(Rails.root, "public", Less::More.destination_path)).join(*path_as_array)
      destination.dirname.mkpath

      File.open(destination, "w") {|f|
        f.puts css
      }
      
      # Let people know what happened.
      puts path.to_s
      puts "  => " + destination.to_s
    end
    
    puts
    puts "Done."

  end
  
  desc "Remove generated CSS files"
  task :clean => :environment do
    puts "Deleting files.."
    
    Less::More.clean

    puts "Done."
  end
end
namespace :more do
  desc "Generate CSS files from LESS files"
  task :generate => :environment do
    puts "Generating css from less files in #{Less::More.source_path}."
    Less::More.generate_all
    puts "Done."

  end
  
  desc "Remove generated CSS files"
  task :clean => :environment do
    puts "Deleting all generated css files in #{Less::More.destination_path}"
    Less::More.remove_all_generated
    puts "Done."
  end
end
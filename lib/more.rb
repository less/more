# Less::More provides methods for parsing LESS files in a rails application to CSS target files.
# 
# When Less::More.parse is called, all files in Less::More.source_path will be parsed using LESS
# and saved as CSS files in Less::More.destination_path. If Less::More.compression is set to true,
# extra line breaks will be removed to compress the CSS files.
#
# By default, Less::More.parse will be called for each request in `development` environment and on
# application initialization in `production` environment.

class Less::More
  class << self

    attr_accessor_with_default :compression, (Rails.env == "production" ? true : false)
    
    # Returns true if compression is enabled. By default, compression is enabled in the production environment
    # and disabled in the development and test environments. This value can be changed using:
    #
    #   Less::More.compression = true
    #
    # You can put this line into config/environments/development.rb to enable compression for the development environments
    def compression?
      self.compression
    end
    
    # Returns the LESS source path, see `source_path=`
    def source_path
      @source_path || Rails.root.join("app", "stylesheets")
    end
    
    # Sets the source path for LESS files. This directory will be scanned recursively for all *.less files. Files prefixed
    # with an underscore is considered to be partials and are not parsed directly. These files can be included using `@import`
    # statements. *Example partial filename: _form.less*
    #
    # Default value is app/stylesheets
    #
    # Examples:
    #   Less::More.source_path = "/path/to/less/files"
    #   Less::More.source_path = Pathname.new("/other/path")
    def source_path=(path)
      @source_path = Pathname.new(path.to_s)
    end
    
    # Returns the destination path for the parsed CSS files, see `destination_path=`
    def destination_path
      @destination_path || Rails.root.join("public", "stylesheets")
    end
    
    # Sets the destination path for the parsed CSS files. The directory structure from the source path will be retained, and
    # all files, except partials prefixed with underscore, will be available with a .css extension.
    #
    # Default value is public/stylesheets
    #
    # Examples:
    #   Less::More.destination_path = "/path/to/css/files"
    #   Less::More.destination_path = Pathname.new("/other/path")
    def destination_path=(path)
      @destination_path = Pathname.new(path.to_s)
    end
    
    # Returns a collection of matching files in the source path, which will be parsed.
    #
    # Example:
    #   Less::More.map => [{ :source => #<Pathname:...>, :destination => #<Pathname:...> }, ...]
    def map
      files = Pathname.glob(self.source_path.join("**", "*.less")).reject { |f| f.basename.to_s.starts_with? "_" }
      
      files.collect! do |file|
        relative_path = file.relative_path_from(self.source_path)
        { :source => file, :destination => self.destination_path.join(relative_path.dirname, relative_path.basename(relative_path.extname).to_s + ".css") }
      end
    end

    # Performs the core functionality of passing the LESS files from the source path through LESS and outputting CSS files to
    # the destination path. The LESS files will only be parsed if the CSS file is not present, or if the modification time of
    # the LESS file or any of its included files are newer than the CSS files. Imported files are recursively checked for updated
    # modification times.
    #
    # If `compression` is enabled, extra line breaks will be removed.
    #
    # Example:
    #   Less::More.parse
    def parse
      self.map.each do |file|
        file[:destination].dirname.mkpath unless file[:destination].dirname.exist?
        
        modified = self.read_imports(file[:source]).push(file[:source]).max { |x, y| x.mtime <=> y.mtime }.mtime
  
        if !file[:destination].exist? || modified > file[:destination].mtime
          css = Less::Engine.new(file[:source].open).to_css
          css = css.delete " \n" if self.compression?

          file[:destination].open("w") { |f| f.write css }
        end
      end
    end
    
    # Recusively reads import statement from less files and returns an array of `Pathname`. It also checks that
    # the files are present in the filesystem.
    #
    # Example:
    #   p = Pathname.new("/path/to/file")
    #   Less::More.read_imports(p) => [#<Pathname:/path/to/include1>, #<Pathname:/path/to/include2>, ...]
    def read_imports(file)
      imports = file.read.scan(/@import\s+(['"])(.*?)\1/i)
      
      imports.collect! do |v|
        path = file.dirname.join(v.last + ".less")
        path.exist? ? self.read_imports(path).push(path) : nil
      end
      
      imports.flatten.compact.uniq
    end
  
  end
end
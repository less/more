`more`: LESS in Rails apps
==========================

**LESS** is a great gem that extends the standard CSS syntax with lots of good stuff. If you are not already using it, take
a look at [http://lesscss.org](http://lesscss.org).

By default, **LESS** does not include any Rails specific functionality, which is why you need this Rails plugin. The usage of
the plugin is very simple and you don't even need to change any of your code. The plugin does the following:

* Recursively looks for **LESS** (.less) files in `app/stylesheets`
* Ignores partials (prefixed with underscore: `_partial.less`) - these can be included with `@import` in your **LESS** files
* Saves the resulting CSS files to `public/stylesheets` using the same directory structure as `app/stylesheets`

Of course all this can be configured, see *Configuration* below.


Installation
============

As a Rails Plugin
-----------------

Use this to install as a plugin in a Ruby on Rails app:

	$ script/plugin install git://github.com/cloudhead/more.git


As a Rails Plugin (using git submodules)
----------------------------------------

Use this if you prefer the idea of being able to easily switch between using edge or a tagged version:

	$ git submodule add git://github.com/cloudhead/more.git vendor/plugins/more
	$ script/runner vendor/plugins/more/install.rb


Usage
=====

When you have installed this plugin, a new directory will be created in `app/stylesheets`. Put your **LESS** files in
this directory and they will automatically be parsed on the next request.

Any **LESS** file in `app/stylesheets` will be parsed to an equivalent **CSS** file in `public/stylesheets`. Example:

	app/stylesheets/clients/screen.less => public/stylesheets/clients/screen.css
	
If you prefix a file with an underscore, it is considered to be a partial, and will not be parsed unless included in another
file. Example:

	<file: app/stylesheets/clients/partials/_form.less>
	@text_dark: #222;
	
	<file: app/stylesheets/clients/screen.less>
	@import "partials/_form";
	
	input { color: @text_dark; }


Configuration
-------------

If you want to configure `more` in a specific environment, put these configuration into the environment file, such
as `config/environments/development.rb`. If you wish to apply the configuration to all environments, put them in `config/environment.rb`.

To set the source path (the location of your **LESS** files)

	Less::More.source_path = "/path/to/less/files"

To set the destination path (the location of the parsed **CSS** files)

	Less::More.destination_path = "/path/to/css/files"

`more` can compress your files by removing extra line breaks. This is enabled by default in the `production` environment. To change
this setting, set

	Less::More.compression = true


Tasks
=====

`more` provides a couple of Rake tasks to help manage your CSS files.

To parse all LESS files and save the resulting CSS files to the destination path, run

	$ rake more:parse

To delete all generated CSS files, run

	$ rake more:clean

This task will not delete any CSS files from the destination path, that does not have a corresponding LESS file in
the source path


Documentation
=============

To view the full RDoc documentation, go to [http://rdoc.info/projects/cloudhead/more](http://rdoc.info/projects/cloudhead/more)

For more information about LESS, see [http://lesscss.org](http://lesscss.org)


Contributors
============
* August Lilleaas
* Logan Raarup
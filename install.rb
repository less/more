require "fileutils"
include FileUtils::Verbose

mkdir_p File.join(Rails.root, "app", "stylesheets")
mkdir_p File.join(Rails.root, "tmp", "less-cache")
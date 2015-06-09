# Generates the statistics website

def generate_website(path, gc_user)

  puts "Generating statistics website..."

  # Delete old generated page and create new directory for putting it
  if Dir.exist? path
    FileUtils.rm_r path
  end
  Dir.mkdir(path)
  Dir.mkdir(File.join(path, "details"))

  # Load all generator functions
  file_root = File.dirname(File.absolute_path(__FILE__))
  Dir.glob(file_root + '/gcdir/*.rb', &method(:require))

  # Call the individual generator functions
  genIndex("", gc_user, path)
  genDetails("../", gc_user, path)
  genStats("", gc_user, path)

end

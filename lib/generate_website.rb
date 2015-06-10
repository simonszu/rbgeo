# Generates the statistics website

def generate_website()

  gc_user = $config['credentials']['username']
  path = $config['generate']['path']

  puts "Generating website..."

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
  print "Generating Index page..."
  genIndex("", gc_user, path)
  print "Generating found page..."
  genFound("", gc_user, path)
  print "Generating details pages..."
  genDetails("../", gc_user, path)
  print "Generating statistics...\n"
  genStats("", gc_user, path)

end

# Generates the index file of the gcdir

def genIndex(prefix, user, dirname)

  # Collect necessary data
  name = user
  path_prefix = prefix
  path = dirname
  caches = Cache.all

  # Generate the index file
  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)
  index_template = File.open(File.join(File.dirname(__FILE__), "templates", "index.erb"), 'r').read
  erb = ERB.new(index_template)
  File.open(File.join(path, "index.html"), "w") { |file|
    file.write(erb.result(binding))}
end
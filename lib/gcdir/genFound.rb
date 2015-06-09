# Generates the index file of the gcdir

def genFound(prefix, user, dirname)

  # Collect necessary data
  name = user
  path_prefix = prefix
  path = dirname

  # Generate the index file
  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)
  index_template = File.open(File.join(File.dirname(__FILE__), "templates", "found.erb"), 'r').read
  erb = ERB.new(index_template)
  File.open(File.join(path, "found.html"), "w") { |file|
    file.write(erb.result(binding))}
end

# Generates the table of all logged caches

def genFound(prefix, user, dirname)

  # Collect necessary data
  name = user
  path_prefix = prefix
  path = dirname

  # Generate the file
  # Read the partials
  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)

  # Read the actual content
  logged_template = File.open(File.join(File.dirname(__FILE__), "templates", "logged.erb"), 'r').read
  
  # Generate and save the page
  erb = ERB.new(logged_template)
  File.open(File.join(path, "logged.html"), "w") { |file|
    file.write(erb.result(binding))}
end

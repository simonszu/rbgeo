# Generates the details page for each cache

def genDetails(prefix, user, dir)

  # Collect necessary data
  path_prefix = prefix
  name = user
  path = dir

  # Generate the details page for each cache
  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)
  details_template = File.open(File.join(File.dirname(__FILE__), "templates", "details.erb"), 'r').read
  Cache.each do |cache|
    erb = ERB.new(details_template)
    File.open(File.join(path, "details", "#{cache.gcid}.html"), "w") { |file|
    file.write(erb.result(binding))}
  end
end

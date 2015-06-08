# Generates some statistics

def genStats(prefix, user, dir)

  # Collect necessary data
  path_prefix = prefix
  name = user
  path = dir

  # Generate the statistic file
  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)

  # General statistics
  general_stats = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "general.erb"), 'r').read).result(binding)

  stats_template = File.open(File.join(File.dirname(__FILE__), "templates", "stats.erb"), 'r').read
  erb = ERB.new(stats_template)
  File.open(File.join(path, "stats.html"), "w") { |file|
    file.write(erb.result(binding))}
end
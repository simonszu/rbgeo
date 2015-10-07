# Generates some statistics

def genStats(prefix, user, dir)

  # Collect necessary data
  path_prefix = prefix
  name = user
  path = dir

  home_lat = $config['homekoords']['lat']
  home_lon = $config['homekoords']['lon']

  # Generate the statistic file
  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)

  # Read the statistics templates and store their results so we can use them in stats.erb

  print "General statistics..."
  general_stats = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "general.erb"), 'r').read).result(binding)

  print "Milestones..."
  milestones = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "milestones.erb"), 'r').read).result(binding)

  print "D/T Matrix..."
  dtmatrix = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "dtmatrix.erb"), 'r').read).result(binding)

  print "Found containers..."
  sizes_found = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "sizes_found.erb"), 'r').read).result(binding)

  print "Found types..."
  types_found = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "types_found.erb"), 'r').read).result(binding)

  print "Owner of founds..."
  owner_found = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "owner_found.erb"), 'r').read).result(binding)

  print "History..."
  history = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "history.erb"), 'r').read).result(binding)

  print "Founds via Hidden-Matrix (Month)..."
  foundsviahiddenmatrix_month = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundsviahiddenmatrix_month.erb"), 'r').read).result(binding)

  print "Founds via Hidden-Matrix (Day)..."
  foundsviahiddenmatrix_day = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundsviahiddenmatrix_day.erb"), 'r').read).result(binding)

  print "Found-Matrix (Month)..."
  foundmatrix_month = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundmatrix_month.erb"), 'r').read).result(binding)

  print "Found-Matrix (Day)..."
  foundmatrix_day = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundmatrix_day.erb"), 'r').read).result(binding)

  print "Founds-Direction-Diagram..."
  founds_direction = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "founds_direction.erb"), 'r').read).result(binding)

  print "Monthly finds as diagram..."
  monthly_diagram = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "monthly_diagram.erb"), 'r').read).result(binding)

  print "Founds via Country..."
  founds_country = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "founds_country.erb"), 'r').read).result(binding)

  print "Distances..."
  distance = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "distance.erb"), 'r').read).result(binding)

  # Read the stats template to generate the statistics page
  stats_template = File.open(File.join(File.dirname(__FILE__), "templates", "stats.erb"), 'r').read
  erb = ERB.new(stats_template)
  # Save the statistics page
  File.open(File.join(path, "stats.html"), "w") { |file|
    file.write(erb.result(binding))}

  print "OK\n"
end

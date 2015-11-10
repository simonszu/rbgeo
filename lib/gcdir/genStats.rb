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

  puts "  General statistics..."
  general_stats = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "general.erb"), 'r').read).result(binding)

  puts "  Milestones..."
  milestones = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "milestones.erb"), 'r').read).result(binding)

  puts "  D/T Matrix..."
  dtmatrix = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "dtmatrix.erb"), 'r').read).result(binding)

  puts "  Found containers..."
  sizes_found = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "sizes_found.erb"), 'r').read).result(binding)

  puts "  Found types..."
  types_found = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "types_found.erb"), 'r').read).result(binding)

  puts "  Owner of founds..."
  owner_found = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "owner_found.erb"), 'r').read).result(binding)

  puts "  History..."
  history = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "history.erb"), 'r').read).result(binding)

  puts "  Founds via Hidden-Matrix (Month)..."
  foundsviahiddenmatrix_month = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundsviahiddenmatrix_month.erb"), 'r').read).result(binding)

  puts "  Founds via Hidden-Matrix (Day)..."
  foundsviahiddenmatrix_day = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundsviahiddenmatrix_day.erb"), 'r').read).result(binding)

  puts "  Found-Matrix (Month)..."
  foundmatrix_month = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundmatrix_month.erb"), 'r').read).result(binding)

  puts "  Found-Matrix (Day)..."
  foundmatrix_day = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "foundmatrix_day.erb"), 'r').read).result(binding)

  puts "  Founds-Direction-Diagram..."
  founds_direction = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "founds_direction.erb"), 'r').read).result(binding)

  puts "  Monthly finds as diagram..."
  monthly_diagram = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "monthly_diagram.erb"), 'r').read).result(binding)

  puts "  Founds via Country..."
  founds_country = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "founds_country.erb"), 'r').read).result(binding)

  puts "  Founds via Region..."
  founds_region = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "founds_region.erb"), 'r').read).result(binding)
 
  puts "  Founds-Map..."
  founds_map = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "founds_map.erb"), 'r').read).result(binding)

  puts "  Favorites..."
  favlist = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "favlist.erb"), 'r').read).result(binding)

  puts "  Distances..."
  distance = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "stats", "distance.erb"), 'r').read).result(binding)

  # Read the stats template to generate the statistics page
  stats_template = File.open(File.join(File.dirname(__FILE__), "templates", "stats.erb"), 'r').read
  erb = ERB.new(stats_template)
  # Save the statistics page
  File.open(File.join(path, "stats.html"), "w") { |file|
    file.write(erb.result(binding))}

  puts "OK"
end

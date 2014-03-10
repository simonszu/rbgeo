def generate(path, gc_user)
  # Delete old generated page and create new directory for putting it
  if Dir.exist? path
    FileUtils.rm_r path
  end
  Dir.mkdir(path)
  Dir.mkdir(File.join(path, "details"))

  name = gc_user

  #cachestatement = @db.prepare("SELECT * FROM caches")
  caches = @db.execute("SELECT * FROM caches")

  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)


  # Generate the index file
  index_template = File.open(File.join(File.dirname(__FILE__), "templates", "index.erb"), 'r').read
  erb = ERB.new(index_template)
  File.open(File.join(path, "index.html"), "w") { |file|
    file.write(erb.result(binding))}
  
  # Generate the details page for each cache
  details_template = File.open(File.join(File.dirname(__FILE__), "templates", "details.erb"), 'r').read
  caches.each do |cache|
    erb = ERB.new(details_template)
    File.open(File.join(path, "details", "#{cache[1]}.html"), "w") { |file|
    file.write(erb.result(binding))}
  end

  # Generate the statistic file
  stats_template = File.open(File.join(File.dirname(__FILE__), "templates", "stats.erb"), 'r').read
  erb = ERB.new(stats_template)
  File.open(File.join(path, "stats.html"), "w") { |file|
    file.write(erb.result(binding))}

  #cachestatement.close  
end
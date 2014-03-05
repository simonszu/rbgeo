def generate(path, gc_user)
  # Delete old generated page and create new directory for putting it
  if Dir.exist? path
    FileUtils.rm_r path
  end
  Dir.mkdir(path)

  name = gc_user

  header_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "header.erb"), 'r').read).result(binding)
  footer_partial = ERB.new(File.open(File.join(File.dirname(__FILE__), "templates", "partials", "footer.erb"), 'r').read).result(binding)


  # Generate the index file
  index_template = File.open(File.join(File.dirname(__FILE__), "templates", "index.erb"), 'r').read
  erb = ERB.new(index_template)
  File.open(File.join(path, "index.html"), "w") { |file|
    file.write(erb.result(binding))}
  


end
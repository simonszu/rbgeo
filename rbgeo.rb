#! /usr/bin/env ruby
# coding: utf-8

require 'bundler'
Bundler.require

$stdout.sync = true

# Parse the command line options
opts = Slop.parse do |o|
  o.banner = "Usage: rbgeo [options] ..."
  o.separator ""
  o.separator "Parsing functions: "
  o.bool '-l', '--parse-logs', 'parse the logs'
  o.bool '-o', '--parse-owns', 'parse the owns'
  o.separator "Generating website functions: "
  o.bool '-w', '--generate-website', 'generate the website'
  o.on  '-h', '--help', 'outputs the help' do
    puts o
    exit
  end
end

# Check if there are command line options:
if ((opts.parse_logs?) || (opts.parse_owns?) || (opts.generate_website?))
  # Save the starting time for benchmarking
  beginning_time = Time.now

  project_root = File.dirname(File.absolute_path(__FILE__))
  Dir.glob(project_root + '/lib/*.rb', &method(:require))
  puts "This is rbgeo version 0.1."

  # Load the config and make it globally accessible for every function
  $config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))


  # Connect and initialize db
  init_db

  if opts.parse_logs?
    parse_logs_gc()
  end
  if opts.parse_owns?
    parse_owns_gc()
  end
  if opts.generate_website?
    generate_website()
  end

  ActiveRecord::Base.connection.close

  # Check the end time and calculate the running duration
  end_time = Time.now

  puts "All done. Time elapsed #{(end_time - beginning_time).round(2)} seconds."

  puts "Bye."
else
  puts opts
end

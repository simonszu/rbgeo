#! /usr/bin/env ruby
# coding: utf-8

$stdout.sync = true

require 'mechanize'
require 'nokogiri'
require 'yaml'
require 'open-uri'
require 'sqlite3'
require 'fileutils'
require 'erb'
require 'active_record'
require 'geocoder'
require 'googlecharts'

# Save the starting time for benchmarking
beginning_time = Time.now

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/lib/*.rb', &method(:require))
puts "This is rbgeo version 0.1."

# Load the config and make it globally accessible for every function
$config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))

# Connect and initialize db
init_db

parse_logs_gc()
parse_owns_gc()
generate_website()

ActiveRecord::Base.connection.close

# Check the end time and calculate the running duration
end_time = Time.now

puts "All done. Time elapsed #{(end_time - beginning_time).round(2)} seconds."

puts "Bye."

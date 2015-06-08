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

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/lib/*.rb', &method(:require))
puts "This is rbgeo version 0.1."

# Load the config
config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))
gc_user = config['credentials']['username']
gc_passwd = config['credentials']['password']

path = config['generate']['path']

# Connect and initialize db
init_db

#parse_gc(gc_user, gc_passwd)
generate_website(path, gc_user)

ActiveRecord::Base.connection.close
puts "Bye."
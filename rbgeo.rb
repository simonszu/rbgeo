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

require_relative 'constants.rb'
require_relative 'gc-parse.rb'
require_relative 'generate.rb'

puts "This is rbgeo version 0.1."

# Load the config
config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))
gc_user = config['credentials']['username']
gc_passwd = config['credentials']['password']

path = config['generate']['path']

#gcparse(gc_user, gc_passwd)
generate(path, gc_user)

puts "Bye."
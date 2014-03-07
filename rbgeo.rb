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

# Connect to DB
begin
  if File.file?(GC_CACHEDB)
    @db = SQLite3::Database.open GC_CACHEDB
  else
    @db = SQLite3::Database.new GC_CACHEDB
    @db.execute "CREATE TABLE IF NOT EXISTS caches(id INTEGER PRIMARY KEY, gcid TEXT, name TEXT, owner TEXT, cachetype TEXT, size TEXT, difficulty REAL, terrain REAL, coords TEXT, area TEXT, hiddendate INTEGER, status TEXT, favcount INTEGER, guid TEXT, logtype TEXT, logdate INTEGER, favorite INTEGER, log TEXT)"
  end
rescue SQLite3::Exception => e
  puts "Fehler beim Zugriff oder Anlegen der Datenbank."
  puts e
  puts "In den meisten Fällen reicht es, das Datenbankfile #{GC_CACHEDB} zu löschen, und alle Caches erneut einzulesen."
  exit
end

#gcparse(gc_user, gc_passwd)
generate(path, gc_user)

@db.close
puts "Bye."
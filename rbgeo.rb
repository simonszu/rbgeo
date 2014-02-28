#! /usr/bin/env ruby
# coding: utf-8

$stdout.sync = true

require 'mechanize'
require 'nokogiri'
require 'yaml'
require 'open-uri'
require 'sqlite3'

require_relative 'constants.rb'

puts "This is rbgeo version 0.1."

# Load the config
config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))
gc_user = config['credentials']['username']
gc_passwd = config['credentials']['password']

# Create a new agent
a = Mechanize.new {|agent|
  agent.user_agent_alias = 'Mac Safari'}

# Create or open the database
begin
  if File.file?(CACHEDB)
    db = SQLite3::Database.open CACHEDB
  else
    db = SQLite3::Database.new CACHEDB
    db.execute "CREATE TABLE IF NOT EXISTS caches(id INTEGER PRIMARY KEY, gcid TEXT, name TEXT, owner TEXT, cachetype TEXT, size TEXT, difficulty REAL, terrain REAL, coords TEXT, area TEXT, hiddendate INTEGER, status TEXT, favcount INTEGER, guid TEXT, logtype TEXT, logdate INTEGER, favorite INTEGER, log TEXT)"
  end
rescue SQLite3::Exception => e
  puts "Fehler beim Zugriff oder Anlegen der Datenbank."
  puts e
  puts "In den meisten Fällen reicht es, das Datenbankfile #{CACHEDB} zu löschen, und alle Caches erneut einzulesen."
  exit
end

puts "Logging in..."

# Login
a.get(LOGIN_PAGE) do |login_page|
  login_page.form_with(:name => 'aspnetForm') do |f|
    f['ctl00$ContentBody$tbUsername'] = gc_user
    f['ctl00$ContentBody$tbPassword'] = gc_passwd
  end.click_button
end

puts "Loading caches which are updated or not in the DB at all..."

# List my founds
a.get(MY_PAGE).search("table.Table tr").each do |cachetable|

  # Get basic details
  favorite = 0
  status = "Available"
  name = cachetable.css("a")[1].inner_text.strip
  logtype = cachetable.css("img")[0]["title"].strip
  if (logtype.eql? "Will Attend")
    next
  end
  if cachetable.css("a > span[class = 'Strike']").length > 0
    status = "Disabled"
  elsif cachetable.css("a > span[class = 'Strike OldWarning']").length > 0
    status = "Archived"
  end
  cachetable.css("td")[2].inner_text.strip.match(/(\d{2})\/(\d{2})\/(\d{4})/)
  logdate = Time.new($3, $1, $2).to_i
  if cachetable.css("img").length == 3
    cachetype = cachetable.css("img")[2]["title"].strip
    favorite = 1
  else
    cachetype = cachetable.css("img")[1]["title"].strip
  end
  nbsp = Nokogiri::HTML("&nbsp;").text
  area = cachetable.css("td")[4].inner_text.gsub(nbsp, "").strip
  cachetable.css("a")[0]["href"].match(/http:\/\/www\.geocaching\.com\/seek\/cache_details\.aspx\?guid=(.+)/)
  guid = $1

  # Check if detailed details differ from stored details or check if the cache isn't stored at all
  storedcache = db.execute("SELECT * FROM caches WHERE guid = '#{guid}'")
  if (storedcache.empty?) || (storedcache[0][2] != name) || (storedcache[0][14] != logtype) || (storedcache[0][11] != status) || (storedcache[0][15].to_i != logdate) || (storedcache[0][16].to_i != favorite) || (storedcache[0][9] != area)
    # Get detailed details
    print "Loading details for #{name}..."
    begin
      detailpage = a.get(cachetable.css("a")[1]["href"])
      owner = detailpage.search("div[id = 'ctl00_ContentBody_mcd1'] a")[0].inner_text
      detailpage.search("span[id = 'ctl00_ContentBody_uxLegendScale'] img")[0]["alt"].match(/(.{1,3}) out of 5/)
      difficulty = $1.to_f
      detailpage.search("span[id = 'ctl00_ContentBody_Localize12'] img")[0]["alt"].match(/(.{1,3}) out of 5/)
      terrain = $1.to_f
      detailpage.search("span.minorCacheDetails img")[0]["alt"].match(/Size: (.+)/)
      size = $1
      coords = detailpage.search("span[id = 'uxLatLon']")[0].inner_text
      detailpage.search("div[id='ctl00_ContentBody_mcd2']")[0].inner_text.match(/(\d{2})\/(\d{2})\/(\d{4})/)
      hiddendate = Time.new($3, $1, $2).to_i
      if detailpage.search("span.favorite-value").length > 0
        favcount = detailpage.search("span.favorite-value")[0].inner_text
      else
        favcount = 0
      end
      gcid = detailpage.search("span[id='ctl00_ContentBody_CoordInfoLinkControl1_uxCoordInfoCode']")[0].inner_text
    rescue
      owner = "N.N"
      difficulty = 0
      terrain = 0
      size = "-"
      coords = "-"
      favcount = 0
      hiddendate = 0
      gcid = "NOT_PUBLISHED"
    end
    print "OK\n"
    sleep (1..5).to_a.sample

    # Get the log
    print "Loading log for #{name}..." 
    log = a.get(cachetable.css("a")[2]["href"]).search("span[id = 'ctl00_ContentBody_LogBookPanel1_LogText']")[0].inner_text.strip
    print "OK\n"
    sleep (1..5).to_a.sample

    # Insert into DB
    db.execute("INSERT INTO caches (gcid, name, status, owner, difficulty, terrain, size, hiddendate, coords, favcount, logtype, logdate, cachetype, area, favorite, log, guid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [gcid, name, status, owner, difficulty, terrain, size, hiddendate, coords, favcount, logtype, logdate, cachetype, area, favorite, log, guid])
  end 
end

db.close
puts "Bye."
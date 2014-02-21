#! /usr/bin/env ruby

require 'mechanize'
require 'nokogiri'
require 'yaml'
require 'open-uri'

CONFIG_FILE = 'config.yaml'

LOGIN_PAGE = 'https://www.geocaching.com/login/'
MY_PAGE = 'http://www.geocaching.com/my/logs.aspx'

LOGTYPES = ["Found it", "Didn't find it", "Will attend", "Owner Maintenance", "Needs Maintenance", "Needs Archived", "Archive", "Enable Listing", "Temporarily Disable Listing", "Post Reviewer Note", "Webcam Photo Taken", "Write note", "Attended"]
CACHETYPES = ["Multi-cache", "Traditional Cache", "Event Cache", "Unknown Cache", "Webcam Cache", "Lost and Found Event Cache", "Earthcache"]

# Load the config
config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))
gc_user = config['credentials']['username']
gc_passwd = config['credentials']['password']

# Create a new agent
a = Mechanize.new {|agent|
  agent.user_agent_alias = 'Mac Safari'}

puts "This is rbgeo version 0.1."
puts "Logging in..."

# Login
a.get(LOGIN_PAGE) do |login_page|
  login_page.form_with(:name => 'aspnetForm') do |f|
    f['ctl00$ContentBody$tbUsername'] = gc_user
    f['ctl00$ContentBody$tbPassword'] = gc_passwd
  end.click_button
end

puts "Loading your caches..."

# List my founds
a.get(MY_PAGE).search("table.Table tr").each do |cachetable|
  favorite = false
  name = cachetable.css("a")[1].inner_text.strip
  logtype = cachetable.css("img")[0]["title"].strip
  logdate = cachetable.css("td")[2].inner_text.strip
  if cachetable.css("img").length == 3
    cachetype = cachetable.css("img")[2]["title"].strip
    favorite = true
  else
    cachetype = cachetable.css("img")[1]["title"].strip
  end
  nbsp = Nokogiri::HTML("&nbsp;").text
  area = cachetable.css("td")[4].inner_text.gsub(nbsp, "").strip
  log_page = cachetable.css("a")[2]["href"]
  puts ("#{name} - #{logtype} - #{logdate} - #{cachetype} - #{area} - #{favorite} - #{log_page}")
end

puts "Bye."
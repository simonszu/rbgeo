#! /usr/bin/env ruby

require 'mechanize'
require 'nokogiri'
require 'yaml'
require 'open-uri'

CONFIG_FILE = 'config.yaml'

LOGIN_PAGE = 'https://www.geocaching.com/login/'
MY_PAGE = 'http://www.geocaching.com/my/logs.aspx'

# Load the config
config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))
gc_user = config['credentials']['username']
gc_passwd = config['credentials']['password']

# Create a new agent
a = Mechanize.new {|agent|
  agent.user_agent_alias = 'Mac Safari'}

# Login
a.get(LOGIN_PAGE) do |login_page|
  login_page.form_with(:name => 'aspnetForm') do |f|
    f['ctl00$ContentBody$tbUsername'] = gc_user
    f['ctl00$ContentBody$tbPassword'] = gc_passwd
  end.click_button
end

# List my founds
a.get(MY_PAGE).search("table.Table tr").each do |cachetable|
  puts cachetable.css("a")[1].inner_text
end
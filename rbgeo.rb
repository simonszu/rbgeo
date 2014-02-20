#! /usr/bin/env ruby

require 'mechanize'
require 'nokogiri'
require 'yaml'

CONFIG_FILE = 'config.yaml'

LOGIN_PAGE = 'https://www.geocaching.com/login/'

config = YAML::load(File.open(File.join(File.dirname(__FILE__), CONFIG_FILE)))
gc_user = config['credentials']['username']
gc_passwd = config['credentials']['password']

a = Mechanize.new {|agent|
  agent.user_agent_alias = 'Mac Safari'}

a.get(LOGIN_PAGE) do |login_page|
  start_page = login.page.form_with(:action => )
end
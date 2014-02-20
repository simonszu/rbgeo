#! /usr/bin/env ruby

require 'mechanize'
require 'nokogiri'

a = Mechanize.new {|agent|
  agent.user_agent_alias = 'Mac Safari'}
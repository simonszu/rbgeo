# Connects to geocaching.com and scrapes the logged caches

# coding: utf-8

def parse_owns_gc()

  gc_user = $config['credentials']['username']
  gc_passwd = $config['credentials']['password']

  puts "Reading your owned caches from geocaching.com"
  # Create a new agent
  a = Mechanize.new {|agent|
    agent.user_agent_alias = 'Mac Safari'}

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
  a.get(MY_OWNS_PAGE).search("table.MyOwnedCachesTable tr.UserOwned").reverse_each do |cachetable|
    #puts cachetable

    # Get basic details
    status = "Available"
    name = cachetable.css("a.lnk span").inner_text.strip
    # Determine if the cache is normal, disabled or archived
    if cachetable.css("a[class = 'lnk Strike']").length > 0
      status = "Disabled"
    elsif cachetable.css("a[class = 'lnk OldWarning Strike Strike']").length > 0
      status = "Archived"
    end

    type = cachetable.css("a.lnk img")[0]["title"]

    # Get the GUID of the cache
    cachetable.css("a")[1]["href"].match(/\/seek\/cache_details\.aspx\?guid=(.+)/)
    guid = $1 

    cache = Ownedcache.where(:guid => guid).first_or_create
    cache.status = status
    cache.name = name
    cache.type = type
    cache.save
  end
end

# Connects to geocaching.com and scrapes the logged caches

# coding: utf-8

def parse_logs_gc()

  gc_user = $config['credentials']['username']
  gc_passwd = $config['credentials']['password']

  puts "Lade Funde von geocaching.com"
  # Create a new agent
  a = Mechanize.new {|agent|
    agent.user_agent_alias = 'Mac Safari'}

  puts "Logge ein..."

  # Login
  a.get(LOGIN_PAGE) do |login_page|
    login_page.form_with(:name => 'aspnetForm') do |f|
      f['ctl00$ContentBody$tbUsername'] = gc_user
      f['ctl00$ContentBody$tbPassword'] = gc_passwd
    end.click_button
  end

  puts "Lade neue oder geänderte Caches..."
  puts ""

  # List my founds
  a.get(MY_LOG_PAGE).search("table.Table tr").reverse_each do |cachetable|

    # Get basic details
    favorite = 0
    status = "Available"
    name = cachetable.css("a")[1].inner_text.strip
    logtype = cachetable.css("img")[0]["title"].strip

    # If the logtype clearly states that this cache should be in the owned list, NEXT
    if OWNED_LOGTYPES.include? logtype
      next
    end

    # Determine if the cache is normal, disabled or archived
    if cachetable.css("a > span[class = 'Strike']").length > 0
      status = "Disabled"
    elsif cachetable.css("a > span[class = 'Strike OldWarning']").length > 0
      status = "Archived"
    end

    # Parse the logdate of the cache
    cachetable.css("td")[2].inner_text.strip.match(/(\d{2})\/(\d{2})\/(\d{4})/)
    logdate = Time.new($3, $1, $2).to_i

    # Check if the cache is favorited by the user
    if cachetable.css("img").length == 3
      type = cachetable.css("img")[2]["title"].strip
      favorite = 1
    else
      type = cachetable.css("img")[1]["title"].strip
    end

    # Get the are of the cache
    nbsp = Nokogiri::HTML("&nbsp;").text
    area = cachetable.css("td")[4].inner_text.gsub(nbsp, "").strip
    # Read country and regional areas, e.g. Bundeslaender
    area.match(/([^,]+)(, )?(.*)/)
    # Store values for country and region, depending if there is a region defined
    if (!$3.eql? "")
      country = $1
      region = $3
    else
      country = $3
      region = $1
    end


    # Get the GUID of the cache
    cachetable.css("a")[0]["href"].match(/http:\/\/www\.geocaching\.com\/seek\/cache_details\.aspx\?guid=(.+)/)
    guid = $1

    # Try to get the identical cache from the database
    storedcache = Gcache.where(:guid => guid).first

    # If the stored log is already a final one, preserve it and update only the other attributes
    is_final_log = (!Gcache.where(:guid => guid).empty?) && (FINAL_LOGTYPES.include? storedcache.logtype)

    # If the cache isn't already in the DB or if the details have changed...
    # But check if the previous log was already final if the log-attributes should have changed
    if (Gcache.where(:guid => guid).empty? || (storedcache.name != name) || (((storedcache.logtype != logtype) || (storedcache.logdate != logdate)) && !is_final_log) || (storedcache.status != status) ||  (storedcache.favorite != favorite) || (storedcache.country != country) || (storedcache.region != region))
      # Get detailed details
      begin

        # If there are multiple logs present, store only the latest one.
        if (!Gcache.where(:guid => guid).empty? && (storedcache.logdate.to_i > logdate))
          next
        end

        # Open the details page of the cache
        detailpage = a.get(cachetable.css("a")[1]["href"])

        # Get some attributes of the cache
        # First the owner
        owner = detailpage.search("div[id = 'ctl00_ContentBody_mcd1'] a")[0].inner_text
        detailpage.search("div[id = 'ctl00_ContentBody_mcd1'] a")[0]["href"].match(/http:\/\/www\.geocaching\.com\/profile\/\?guid=(.+)&wid.+/)
        owner_guid = $1
        if (owner.eql? gc_user)
          next
        end

        print "Bearbeite \"#{name}\":\n"
        print "  Lade Details...\n"

        # The Difficulty
        detailpage.search("span[id = 'ctl00_ContentBody_uxLegendScale'] img")[0]["alt"].match(/(.{1,3}) out of 5/)
        difficulty = $1.to_f

        # The terrain rating
        detailpage.search("span[id = 'ctl00_ContentBody_Localize12'] img")[0]["alt"].match(/(.{1,3}) out of 5/)
        terrain = $1.to_f

        # The size of the cache container
        detailpage.search("span.minorCacheDetails img")[0]["alt"].match(/Size: (.+)/)
        size = $1

        # The coordinates of the cache
        coords = detailpage.search("span[id = 'uxLatLon']")[0].inner_text
        coords =~ /((N|S) \d+° \d+\.\d+) ((E|W) \d+° \d+\.\d+)/
        coords_lat = $1
        coords_lon = $3

        # The date the cache was hidden
        detailpage.search("div[id='ctl00_ContentBody_mcd2']")[0].inner_text.match(/(\d{2})\/(\d{2})\/(\d{4})/)
        hiddendate = Time.new($3, $1, $2).to_i

        # The favcount of the cache
        if detailpage.search("span.favorite-value").length > 0
          favcount = detailpage.search("span.favorite-value")[0].inner_text
        else
          favcount = 0
        end

        # The GC-ID
        gcid = detailpage.search("span[id='ctl00_ContentBody_CoordInfoLinkControl1_uxCoordInfoCode']")[0].inner_text

      # If something goes wrong, use some default values
      rescue
        next
      end

      # Sleep for a random time between 1 and 5 seconds to not hammer the GC.com servers with requests
      sleep (0..MAX_SLEEPTIME).to_a.sample

      # Get the log
      print "  Lade Log...\n"
      logpage = ""
      # Sometimes the logpage doesn't load properly. Repeat trying to load it, until there is no error
      loop do
        logpage = a.get(cachetable.css("a")[2]["href"])
        break if !logpage.title.eql? "An Error Has Occurred"
      end
      log = logpage.search("span[id = 'ctl00_ContentBody_LogBookPanel1_LogText']")[0].inner_text.strip
      sleep (0..MAX_SLEEPTIME).to_a.sample

      # Store every value into the database
      print "  Speichere in Datenbank..."

      cache = Gcache.where(:guid => guid).first_or_create
      # Update log attributes only if the log isn't final
      if (!is_final_log)
        cache.logtype = logtype
        cache.logdate = logdate
        cache.log = log

        # Set extra flags for found and dnf
        if FOUND_LOGTYPES.include? logtype
          cache.found = 1
          cache.dnf = 0
        elsif logtype.eql? "Didn't find it"
          cache.found = 0
          cache.dnf = 1
        else
          cache.found = 0
          cache.dnf = 0
        end

      end


      # Update every other attribute and save the record
      cache.gcid = gcid
      cache.name = name
      cache.status = status
      cache.owner = owner
      cache.owner_guid = owner_guid
      cache.difficulty = difficulty
      cache.terrain = terrain
      cache.size = size
      cache.hiddendate = hiddendate
      cache.coords_lat = coords_lat
      cache.coords_lon = coords_lon
      cache.favcount = favcount
      cache.type = type
      cache.region = region
      cache.country = country
      cache.favorite = favorite
      cache.save
      print "OK\n\n"
    end
  end
end

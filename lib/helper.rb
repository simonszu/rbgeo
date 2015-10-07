
# Calculates the months between a start and an enddate and stores them in an array
def months_between(start_month, end_month)
  months = []
  ptr = start_month
  while ptr <= end_month do
    months << ptr
    ptr = ptr >> 1
  end
  months
end

# Calculates the years between a start and an endddate and stores them in an array
def years_between(start_year, end_year)
  years = []
  ptr = Date.new(start_year)
  while ptr <= Date.new(end_year) do
    years << ptr
    ptr = ptr >> (1*12)
  end
  years
end

# Check if there are logs written on an individual day
def has_logs(day)
  if Gcache.where("logdate = ? AND (logtype = ? OR logtype = ? OR logtype = ?)", day.to_time.to_i, "Found it", "Attended", "Webcam Photo Taken").length > 0
    return true
  else
    return false
  end
end

# Calculates the distance between 2 coordinate pairs
#distance [46.3625, 15.114444],[46.055556, 14.508333]
def coord_distance loc1, loc2
  rad_per_deg = Math::PI/180  # PI / 180
  rkm = 6371                  # Earth radius in kilometers
  rm = rkm * 1000             # Radius in meters

  dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
  dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

  lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
  lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

  a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

  rm * c # Delta in meters
end

# Converts coords from N 51° 33.123 to N 51.1234
def simplify_coords(coords)
  coords =~ /(N|S|E|W) (\d+)°? (\d+\.\d+)/
  quadrant = $1
  degrees_tmp = $2
  minutes = $3.to_f
  subdegrees = (minutes/60).to_s.gsub(/\./, "")
  subdegrees[0]=''
  degrees = (degrees_tmp.to_s + "." + subdegrees).to_f.round(5)
  if (quadrant.eql?"S") || ($1.eql?"W")
    return (-1)*degrees
  else
    return degrees
  end
end

# Returns the img tag for a given cachetype
def typeicon(type)
  if type.eql? "Traditional Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/2.gif" title="Traditional Cache">'
  elsif type.eql? "Multi-cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/3.gif" title="Multi-cache">'
  elsif type.eql? "Unknown Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/8.gif" title="Unknown Cache">'
  elsif type.eql? "Event Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/6.gif" title="Event Cache">'
  elsif type.eql? "Webcam Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/11.gif" title="Webcam Cache">'
  elsif type.eql? "Earthcache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/earthcache.gif" title="Earthcache">'
  elsif type.eql? "Mega-Event Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/453.gif" title="Mega-Event Cache">'
  elsif type.eql? "Wherigo Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/1858.gif" title="Wherigo Cache">'
  elsif type.eql? "Giga-Event Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/7005.gif" title="Giga-Event Cache">'
  elsif type.eql? "Lost and Found Event Cache"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/3653.gif" title="Lost and Found Event Cache">'
  elsif type.eql? "Letterbox Hybrid"
    str = '<img src="http://www.geocaching.com/images/wpttypes/sm/5.gif" title="Letterbox Hybrid">'
  end
  return str
end

# Returns the img tag for a given cache container size
def sizeicon(size)
  if size.eql? "micro"
    str = '<img src="http://www.geocaching.com/images/icons/container/micro.gif" title="Micro">'
  elsif size.eql? "small"
    str = '<img src="http://www.geocaching.com/images/icons/container/small.gif" title="Small">'
  elsif size.eql? "regular"
    str = '<img src="http://www.geocaching.com/images/icons/container/regular.gif" title="Regular">'
  elsif size.eql? "large"
    str = '<img src="http://www.geocaching.com/images/icons/container/large.gif" title="Large">'
  elsif size.eql? "other"
    str = '<img src="http://www.geocaching.com/images/icons/container/other.gif" title="Other">'
  elsif size.eql? "not chosen"
    str = '<img src="http://www.geocaching.com/images/icons/container/not_chosen.gif" title="Not Chosen">'
  end
  return str
end

# Returns the icon for a certain type of log
def logicon(logtype)
  if logtype.eql? "Found it"
    str = '<img src="http://www.geocaching.com/images/logtypes/2.png" title="Found it">'
  elsif logtype.eql? "Will Attend"
    str = '<img src="http://www.geocaching.com/images/logtypes/9.png" title="Will Attend">'
  elsif logtype.eql? "Owner Maintenance"
    str = '<img src="http://www.geocaching.com/images/logtypes/46.png" title="Owner Maintenance">'
  elsif logtype.eql? "Needs Archived"
    str = '<img src="http://www.geocaching.com/images/logtypes/7.png" title="Needs Archived">'
  elsif logtype.eql? "Didn't find it"
    str = '<img src="http://www.geocaching.com/images/logtypes/3.png" title="Didn\'t find it">'
  elsif logtype.eql? "Archive"
    str = '<img src="http://www.geocaching.com/images/logtypes/5.png" title="Archive">'
  elsif logtype.eql? "Write note"
    str = '<img src="http://www.geocaching.com/images/logtypes/4.png" title="Write note">'
  elsif logtype.eql? "Temporarily Disable Listing"
    str = '<img src="http://www.geocaching.com/images/logtypes/22.png" title="Temporarily Disable Listing">'
  elsif logtype.eql? "Attended"
    str = '<img src="http://www.geocaching.com/images/logtypes/10.png" title="Attended">'
  elsif logtype.eql? "Webcam Photo Taken"
    str = '<img src="http://www.geocaching.com/images/logtypes/11.png" title="Webcam Photo Taken">'
  elsif logtype.eql? "Post Reviewer Note"
    str = '<img src="http://www.geocaching.com/images/logtypes/18.png" title="Post Reviewer Note">'
  elsif logtype.eql? "Enable Listing"
    str = '<img src="http://www.geocaching.com/images/logtypes/23.png" title="Enable Listing">'
  elsif logtype.eql? "Needs Maintenance"
    str = '<img src="http://www.geocaching.com/images/logtypes/45.png" title="Needs Maintenance">'
  end
  return str
end

# Helper function to calculate percent values
def percent(value, base)
  return ((value.to_f/base.to_f)*100).round(1)
end

# Returns actual number and percent of a cache type
def typestats(type)
  allcachecount = Gcache.where(found: "1").length
  thiscount = Gcache.where(type: type).length
  thispercent = percent(thiscount, allcachecount)
  return [thiscount, thispercent]
end

# Returns actual number and percent of a cache container size
def sizestats(size)
  allcachecount = Gcache.where(found: "1").length
  thiscount = Gcache.where(size: size).length
  thispercent = percent(thiscount, allcachecount)
  return [thiscount, thispercent]
end

# Returns actual number and percent of a cache container size
def ownerstats(owner)
  allcachecount = Gcache.where(found: "1").length
  thiscount = Gcache.where(owner: owner).length
  thispercent = percent(thiscount, allcachecount)
  return [thiscount, thispercent]
end
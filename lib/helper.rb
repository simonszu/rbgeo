def months_between(start_month, end_month)
  months = []
  ptr = start_month
  while ptr <= end_month do
    months << ptr
    ptr = ptr >> 1
  end
  months
end

def years_between(start_year, end_year)
  years = []
  ptr = start_year
  while ptr <= end_year do
    years << ptr
    ptr = ptr >> (1*12)
  end
  years
end

def has_logs(day)
  if Cache.where("logdate = ? AND (logtype = ? OR logtype = ? OR logtype = ?)", day.to_time.to_i, "Found it", "Attended", "Webcam Photo Taken").length > 0
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

# Returns actual number and percent of a cache type
def typestats(type)
  allcachecount = Cache.where(found: "1").length
  thiscount = Cache.where(cachetype: type).length
  thispercent = ((thiscount.to_f/allcachecount.to_f)*100).round(1)
  return [thiscount, thispercent]
end

# Returns actual number and percent of a cache container size
def sizestats(size)
  allcachecount = Cache.where(found: "1").length
  thiscount = Cache.where(size: size).length
  thispercent = ((thiscount.to_f/allcachecount.to_f)*100).round(1)
  return [thiscount, thispercent]
end
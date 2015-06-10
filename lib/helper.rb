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

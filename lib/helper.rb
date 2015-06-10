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

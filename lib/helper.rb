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

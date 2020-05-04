SELECT 
  cases.fips, 
  admin2 as county, 
  province_state, 
  confirmed,
  growth_count, 
  sum(num_licensed_beds) as num_licensed_beds, 
  sum(num_staffed_beds) as num_staffed_beds, 
  sum(num_icu_beds) as num_icu_beds
FROM
  "covid-19"."hospital_beds" beds, 
  ( SELECT 
      fips, 
      admin2, 
      province_state, 
      confirmed, 
      last_value(confirmed) over (partition by fips order by last_update) - first_value(confirmed) over (partition by fips order by last_update) as growth_count,
      first_value(last_update) over (partition by fips order by last_update desc) as most_recent,
      last_update
    FROM  
      "covid-19"."enigma_jhu" 
    WHERE 
      from_iso8601_timestamp(last_update) > now() - interval '7' day AND country_region = 'US') cases
WHERE 
  beds.fips = cases.fips AND last_update = most_recent
GROUP BY cases.fips, confirmed, growth_count, admin2, province_state
ORDER BY growth_count desc
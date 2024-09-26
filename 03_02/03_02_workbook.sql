-- Add a new column in trip_data to store the half-hour interval
alter table public.trip_data 
add column half_hour_starttime timestamp;

-- Update the new column with half-hour intervals based on start_time
UPDATE trip_data
SET half_hour_starttime = 
    DATE_TRUNC('hour', start_time::timestamp) + 
    INTERVAL '30 minutes' * FLOOR(EXTRACT(MINUTE FROM start_time::timestamp) / 30);
   
select date_trunc('hour', start_time::timestamp) from trip_data;

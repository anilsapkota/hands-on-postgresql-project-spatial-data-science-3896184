-- goal: group trip data by both ttemporal and spatial dimensions 
-- task: create a new table named spatio_temporal_visualization_05_01 that includes total trip count by census tract and half hour intervals

create table spatio_temporal_visualization_05_01 as 
SELECT half_hour_starttime,
    nyct2020.ogc_fid AS census_tract, -- Group by census tracts from the spatial join
    COUNT(trip_data.ride_id) AS trip_count -- Count trips
FROM 
    public.trip_data
JOIN 
    public.stations ON trip_data.start_station_id = stations.station_id -- Join stations to trip data
JOIN 
    public.nyct2020 ON ST_Within(stations.geom, nyct2020.wkb_geometry) -- Perform spatial join on census tracts
GROUP BY 
    half_hour_starttime, census_tract
ORDER BY 
    census_tract, half_hour_starttime;
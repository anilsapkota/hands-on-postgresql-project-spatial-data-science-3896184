-- hint 1: the spatial reference id for WGS84 latitude and longitude is 4326
-- hint 2: the projection we would like to use for our project is UTM zone 18N (EPSG: 32618)
-- hint 3: working with projection ST_Transform() and ST_SetSRID - https://postgis.net/documentation/tips/st-set-or-transform/

-- Goal: turn stations table into geospatial data format and set the correct projection
-- Step 1: Add a new geometry column to the bike_stations table


-- Step 2: Populate the new geom column using lat and lon columns


-- Step 3: Transform the geometry to UTM Zone 18N projection (EPSG: 32618)

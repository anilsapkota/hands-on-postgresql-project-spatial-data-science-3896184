-- Step 1: Create a column to store the shortest path as geometry (LINESTRING) in trip_data
ALTER TABLE public.trip_data
ADD COLUMN path_geom geometry(LineString, 4326);  -- LineString to store the path

-- Step 2: Create a query to find the nearest road network nodes to start and end stations
WITH start_nodes AS (
  SELECT t.trip_id, t.start_station_id, t.end_station_id, s.geom AS start_geom,
         (SELECT id FROM road_network_nodes ORDER BY geom <-> s.geom LIMIT 1) AS start_node
  FROM public.trip_data t
  JOIN public.stations s ON t.start_station_id = s.station_id
),
end_nodes AS (
  SELECT t.trip_id, n.start_node, s.geom AS end_geom,
         (SELECT id FROM road_network_nodes ORDER BY geom <-> s.geom LIMIT 1) AS end_node
  FROM start_nodes n
  JOIN public.stations s ON n.end_station_id = s.station_id
)

-- Step 3: Calculate the shortest path for each trip using pgRouting
UPDATE public.trip_data td
SET path_geom = (
  SELECT ST_MakeLine(geom)  -- Create a LineString from the points of the shortest path
  FROM pgr_dijkstra(
      'SELECT id, source, target, cost FROM road_network_edges', -- Road network graph
      start_node,                                                 -- Start node for the trip
      end_node                                                    -- End node for the trip
    ) AS route
  JOIN road_network_edges rne ON route.edge = rne.id
  ORDER BY route.seq
)
FROM end_nodes en
WHERE td.trip_id = en.trip_id;
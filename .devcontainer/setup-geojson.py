import json
import psycopg2

# Database connection parameters
DB_NAME = 'postgres'
DB_USER = 'postgres'
DB_PASSWORD = 'postgres'
DB_HOST = 'localhost'
DB_PORT = '5432'

# Load GeoJSON
geojson_file = '/workspace/data/nyct2020.geojson'

with open(geojson_file) as f:
    geojson_data = json.load(f)

# Connect to PostgreSQL
try:
    conn = psycopg2.connect(dbname=DB_NAME, user=DB_USER,
                            password=DB_PASSWORD, host=DB_HOST, port=DB_PORT)
    cur = conn.cursor()

    # Insert data into the table
    for feature in geojson_data['features']:
        # Extract properties and geometry
        properties = feature['properties']
        geom = json.dumps(feature['geometry'])

        # Prepare the insert statement
        cur.execute("""
            INSERT INTO public.nyct2020 (
                shape_area, ntaname, cdtaname, shape_leng, boroname, 
                ct2020, nta2020, borocode, cdeligibil, geoid, 
                boroct2020, cdta2020, ctlabel, wkb_geometry
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, ST_GeomFromGeoJSON(%s))
            RETURNING ogc_fid;  -- Return the primary key if needed
        """, (
            properties.get('shape_area'),
            properties.get('ntaname'),
            properties.get('cdtaname'),
            properties.get('shape_leng'),
            properties.get('boroname'),
            properties.get('ct2020'),
            properties.get('nta2020'),
            properties.get('borocode'),
            properties.get('cdeligibil'),
            properties.get('geoid'),
            properties.get('boroct2020'),
            properties.get('cdta2020'),
            properties.get('ctlabel'),
            geom
        ))

    # Commit changes
    conn.commit()

except Exception as e:
    print(f"An error occurred: {e}")

finally:
    # Close the cursor and connection
    if cur:
        cur.close()
    if conn:
        conn.close()

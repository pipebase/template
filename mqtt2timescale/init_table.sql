CREATE TABLE IF NOT EXISTS weather_metrics (

   time TIMESTAMP NOT NULL,
   timezone_shift int NULL,
   city_name text NULL,
   temp_c double PRECISION NULL,
   feels_like_c double PRECISION NULL,
   temp_min_c double PRECISION NULL,
   temp_max_c double PRECISION NULL,
   pressure_hpa double PRECISION NULL,
   humidity_percent double PRECISION NULL,
   wind_speed_ms double PRECISION NULL,
   wind_deg int NULL,
   rain_1h_mm double PRECISION NULL,
   rain_3h_mm double PRECISION NULL,
   snow_1h_mm double PRECISION NULL,
   snow_3h_mm double PRECISION NULL,
   clouds_percent int NULL,
   weather_type_id int NULL
);

SELECT create_hypertable('weather_metrics','time');
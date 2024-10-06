-- cantidad de viajes en taxi para cada compañía de taxis para el 15 y 16 de noviembre de 2017,
SELECT 
    cabs.company_name AS company_name,
    COUNT(trips.trip_id) AS trips_amount
FROM
    trips
    LEFT JOIN cabs ON cabs.cab_id = trips.cab_id
WHERE
    CAST(trips.start_ts AS date) = '2017-11-15'
    OR CAST(trips.start_ts AS date) = '2017-11-16'
GROUP BY
    cabs.company_name
ORDER BY
    trips_amount DESC;

--  cantidad de viajes para cada empresa de taxis cuyo nombre contenga las palabras "Yellow" o "Blue" del 1 al 7 de noviembre de 2017.
SELECT 
    cabs.company_name AS company_name,
    COUNT(DISTINCT trips.trip_id) AS trips_amount
FROM
    trips
    LEFT JOIN cabs ON cabs.cab_id = trips.cab_id
WHERE
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01'
    AND '2017-11-07'  
GROUP BY
    cabs.company_name
HAVING 
    cabs.company_name LIKE '%Yellow%' OR cabs.company_name LIKE '%Blue%'
ORDER BY
    trips_amount DESC;

-- número de viajes de estas dos empresas y asigna a la variable resultante el nombre trips_amount. 
-- Junta los viajes de todas las demás empresas en el grupo "Other". 
-- Agrupa los datos por nombres de empresas de taxis.
SELECT 
    CASE
    WHEN cabs.company_name NOT IN ('Flash Cab', 'Taxi Affiliation Services') THEN 'Other'
    ELSE cabs.company_name
    END, -- Se clasifica los nombres de las empresas de taxi, donde toda empresa que no sea 'Flash Cab' o 'Taxi Affiliation Services', se marca como 'Other'
    COUNT(trips.trip_id) AS trips_amount -- se cuenta la cantidad de viajes
FROM
    trips
    LEFT JOIN cabs ON cabs.cab_id = trips.cab_id -- Se realiza la unión de las tablas 'cabs' y 'trips' con base al campo 'cab_id'
WHERE
    CAST(trips.start_ts AS date) BETWEEN '2017-11-01'
    AND '2017-11-07' -- Se aplica el filtro para obtener los viajes en la fecha requerida
GROUP BY CASE
    WHEN cabs.company_name NOT IN ('Flash Cab', 'Taxi Affiliation Services') THEN 'Other'
    ELSE cabs.company_name
    END -- Se utiliza el comando CASE utilizado para clasifica los nombres de las empresas, para agrupar la consulta por nombre de las empresas.
ORDER BY
    trips_amount DESC;  -- Se ordena el resultado

-- Recupera los identificadores de los barrios de O'Hare y Loop de la tabla neighborhoods.
SELECT
    neighborhood_id AS neighborhood_id,
    name AS name
FROM
    neighborhoods
WHERE
    neighborhoods.name LIKE 'Loop' OR neighborhoods.name LIKE '%Hare'

-- Para cada hora recupera los registros de condiciones meteorológicas de la tabla weather_records. 
-- divide todas las horas en dos grupos: Bad si el campo description contiene las palabras rain o storm, y Good para los demás. 
SELECT
    ts As ts,
    CASE
    WHEN description LIKE '%rain%' OR description LIKE '%storm%' THEN 'Bad'
    ELSE 'Good'
    END AS weather_conditions
FROM
    weather_records

-- Recupera de la tabla de trips todos los viajes que comenzaron en el Loop (pickup_location_id: 50) el sábado y terminaron en O'Hare (dropoff_location_id: 63).
-- Obtén las condiciones climáticas para cada viaje. 
-- Recupera también la duración de cada viaje. Ignora los viajes para los que no hay datos disponibles sobre las condiciones climáticas
SELECT 
    trips.start_ts AS start_ts,
    subq.weather_conditions,
    trips.duration_seconds AS duration_seconds
FROM
    trips
INNER JOIN (
    SELECT
        weather_records.ts AS ts,
        CASE
            WHEN weather_records.description LIKE '%rain%' OR weather_records.description LIKE '%storm%' THEN 'Bad'
            ELSE 'Good'
        END AS weather_conditions
    FROM 
        weather_records) AS subq ON subq.ts = trips.start_ts
WHERE
    trips.pickup_location_id = 50
    AND trips.dropoff_location_id = 63
    AND EXTRACT(DOW FROM start_ts) = 6
ORDER BY
    trip_id;
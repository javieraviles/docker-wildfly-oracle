# Dockerfile
FROM wnameless/oracle-xe-11g

ADD 00_create_database_schema.sql /docker-entrypoint-initdb.d/
ADD 01_drop_all.sql /docker-entrypoint-initdb.d/
ADD 02_create_data_structure_tables.sql /docker-entrypoint-initdb.d/
ADD 03_create_grants.sql /docker-entrypoint-initdb.d/
ADD 04_populate_database.sql /docker-entrypoint-initdb.d/
# ADD script.sh /docker-entrypoint-initdb.d/
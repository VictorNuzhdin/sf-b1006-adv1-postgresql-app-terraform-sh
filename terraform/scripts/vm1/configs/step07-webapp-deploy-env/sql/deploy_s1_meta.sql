/* DEPLOYING WEBAPP ENVIRONMENT step1 */

--Creating User and Database and set User access permissions
CREATE USER pyuser WITH PASSWORD 'pyuser@pg_pass';
CREATE DATABASE pydb;
GRANT ALL PRIVILEGES ON DATABASE pydb to pyuser;

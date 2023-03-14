-- Use an admin role
USE ROLE ACCOUNTADMIN;

-- Create the `flix_transform` role
CREATE ROLE IF NOT EXISTS flix_transform;
GRANT ROLE FLIX_TRANSFORM TO ROLE ACCOUNTADMIN;

-- Create the default warehouse if necessary
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH;
GRANT OPERATE ON WAREHOUSE COMPUTE_WH TO ROLE FLIX_TRANSFORM;

-- Create the `dbt` user and assign to role
CREATE USER IF NOT EXISTS dbt
  PASSWORD='dbtPassword123'
  LOGIN_NAME='dbt'
  MUST_CHANGE_PASSWORD=FALSE
  DEFAULT_WAREHOUSE='COMPUTE_WH'
  DEFAULT_ROLE='flix_transform'
  DEFAULT_NAMESPACE='FLIX.RAW'
  COMMENT='DBT user used for FLIX data transformation';
GRANT ROLE flix_transform to USER dbt;

-- Create our database and schemas
CREATE DATABASE IF NOT EXISTS FLIX;
CREATE SCHEMA IF NOT EXISTS FLIX.RAW;
DROP SCHEMA IF EXISTS FLIX.DEV;
-- Set up permissions to role `flix_transform`
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE flix_transform; 
GRANT ALL ON DATABASE FLIX to ROLE flix_transform;
GRANT ALL ON ALL SCHEMAS IN DATABASE FLIX to ROLE flix_transform;
GRANT ALL ON FUTURE SCHEMAS IN DATABASE FLIX to ROLE flix_transform;
GRANT ALL ON ALL TABLES IN SCHEMA FLIX.RAW to ROLE flix_transform;
GRANT ALL ON FUTURE TABLES IN SCHEMA FLIX.RAW to ROLE flix_transform;

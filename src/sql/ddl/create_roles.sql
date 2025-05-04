/* 

Name: create_roles.sql
Purpose: Creates chinook db roles and assigns users
Comment: - Run as securityadmin
         - Replace <your warehouse> with appropriate value

*/

use warehouse <your warehouse>;
use database CHINOOK;

create or replace role DBT_MODEL_RUNNER_ROLE comment = 'Transforms data from landing to core';
create or replace role CHINOOK_LOADER_ROLE comment = 'Loads raw data into landing';

-- chinook_loader grants
grant usage on warehouse JPK_WAREHOUSE to role CHINOOK_LOADER_ROLE;
grant usage on database CHINOOK to role CHINOOK_LOADER_ROLE;
grant usage on schema CHINOOK.LANDING to role CHINOOK_LOADER_ROLE;
grant modify  on schema  CHINOOK.LANDING to role CHINOOK_LOADER_ROLE; 

grant select, insert, update, delete on all tables in schema  CHINOOK.LANDING to role CHINOOK_LOADER_ROLE;
grant select, insert, update, delete on future tables in schema  CHINOOK.LANDING to role CHINOOK_LOADER_ROLE;

grant create table  on schema  CHINOOK.LANDING to role CHINOOK_LOADER_ROLE;
grant create view   on schema  CHINOOK.LANDING to role CHINOOK_LOADER_ROLE;

grant select on all tables in schema CHINOOK.LANDING to role  CHINOOK_LOADER_ROLE;
grant select on future tables in schema  CHINOOK.LANDING to role  CHINOOK_LOADER_ROLE;

grant role  CHINOOK_LOADER_ROLE to user  CHINOOK_LOADER;


-- dbt_model_runner_role grants
grant usage on warehouse JPK_WAREHOUSE to role DBT_MODEL_RUNNER_ROLE;
grant usage on database  CHINOOK to role DBT_MODEL_RUNNER_ROLE;

grant usage on schema  CHINOOK.LANDING to role DBT_MODEL_RUNNER_ROLE;
grant usage on schema  CHINOOK.FOUNDATION to role DBT_MODEL_RUNNER_ROLE;
grant usage on schema  CHINOOK.CORE to role DBT_MODEL_RUNNER_ROLE;

alter schema CHINOOK.FOUNDATION SET DEFAULT ROLE = DBT_MODEL_RUNNER_ROLE;
alter schema CHINOOK.CORE SET DEFAULT ROLE = DBT_MODEL_RUNNER_ROLE;

grant modify  on schema  CHINOOK.FOUNDATION to role DBT_MODEL_RUNNER_ROLE; 
grant modify  on schema  CHINOOK.CORE to role DBT_MODEL_RUNNER_ROLE;

grant select, insert, update, delete on all tables in schema  CHINOOK.FOUNDATION to role  DBT_MODEL_RUNNER_ROLE;
grant select, insert, update, delete on future tables in schema  CHINOOK.FOUNDATION to role  DBT_MODEL_RUNNER_ROLE;

grant select, insert, update, delete on all tables in schema  CHINOOK.CORE to role  DBT_MODEL_RUNNER_ROLE;
grant select, insert, update, delete on future tables in schema  CHINOOK.CORE to role  DBT_MODEL_RUNNER_ROLE;

grant create table  on schema  CHINOOK.FOUNDATION to role DBT_MODEL_RUNNER_ROLE;
grant create view   on schema  CHINOOK.FOUNDATION to role DBT_MODEL_RUNNER_ROLE;

grant create table  on schema  CHINOOK.CORE to role DBT_MODEL_RUNNER_ROLE;
grant create view   on schema  CHINOOK.CORE to role DBT_MODEL_RUNNER_ROLE;

grant select on all tables in schema CHINOOK.LANDING to role DBT_MODEL_RUNNER_ROLE;
grant select on future tables in schema  CHINOOK.LANDING to role DBT_MODEL_RUNNER_ROLE;

grant role  DBT_MODEL_RUNNER_ROLE to user DBT_USER;
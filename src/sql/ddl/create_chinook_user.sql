/*

Create chinook_loader user and role and grant permission



create or replace role chinook_loader_role comment = 'Loads raw data into landing';
GRANT USAGE ON DATABASE chinook TO ROLE CHINOOK_LOADER_ROLE;
GRANT USAGE ON SCHEMA chinook.landing TO ROLE CHINOOK_LOADER_ROLE;
GRANT INSERT ON ALL TABLES IN SCHEMA chinook.landing TO ROLE CHINOOK_LOADER_ROLE;
GRANT CREATE TABLE ON SCHEMA chinook.landing TO ROLE CHINOOK_LOADER_ROLE;
GRANT USAGE ON WAREHOUSE jpk_warehouse TO ROLE CHINOOK_LOADER_ROLE;

create user if not exists chinook_loader password = '*********';
alter user chinook_loader set default_warehouse = '********';
grant role chinook_loader_role to user chinook_loader;
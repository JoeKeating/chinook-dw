/*
Name: create_db_and_schemas.sql
Purpose: Creates chinook db and schemas
Comment: - Run as sysadmin
         - Replace <your warehouse> with appropriate value


*/
use warehouse <your warehouse>;
create or replace database  chinook;

create or replace schema  chinook.landing;
create or replace schema chinook.foundation;
create or replace schema chinook.core;

/*
Name: create_db_and_schemas.sql
Purpose: Creates chinook db and schemas
Comment: Run as sysadmin.

*/
use warehouse <your_warehouse>;
create database if not exists chinook;

create schema if not exists chinook.landing;
create schema if not exists chinook.foundation;
create schema if not exists chinook.core;

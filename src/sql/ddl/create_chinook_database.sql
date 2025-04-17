/*

Create chinook db and schemas

-- Run as Account

*/

create database if not exists chinook;

create schema if not exists chinook.landing;
create schema if not exists chinook.foundation;
create schema if not exists chinook.core;
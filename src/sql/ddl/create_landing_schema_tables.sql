/* 

Creates landing schema tables

*/


create  or replace table landing.genre( 
genre_id        text
,name          text
,datetime_loaded    timestamp_ntz  default current_timestamp()
);

create  or replace table landing.media_type(
media_type_id   text
,name           text
,datetime_loaded    timestamp_ntz  default current_timestamp()
);

create or replace table landing.artist (
artist_id       text
,name           text
,datetime_loaded    timestamp_ntz  default current_timestamp()
);

create  or replace table landing.album (
album_id        text
,title          text
,artist_id      text
,datetime_loaded    timestamp_ntz  default current_timestamp()
);

create  or replace table landing.track (
track_id        text
,name           text
,album_id       text
,media_type_id  text
,genre_id       text
,composer       text
,milliseconds   text
,bytes          text
,unit_price     text
,datetime_loaded     timestamp_ntz  default current_timestamp()
);

create  or replace table landing.employee (
employee_id     text
,last_name      text
,first_name     text
,title          text
,reports_to     text
,birth_date     text
,hire_date      text
,address        text
,city           text
,state          text
,country        text
,postal_code    text
,phone          text
,email          text
,datetime_loaded     timestamp_ntz  default current_timestamp()

);
create  or replace table landing.customer (
customer_id     text
,first_name     text
,last_name      text
,company        text
,address        text
,city           text
,state          text
,country        text
,postal_code    text
,phone          text
,fax            text
,email          text
,supportrepid   text
,datetime_loaded    timestamp_ntz  default current_timestamp()
);

create  or replace table landing.invoice (
invoice_id          text
,customer_id        text
,invoice_date       text
,billing_address    text
,billing_city       text
,billing_state      text
,billing_country    text
,billing_postal_code    text
,total                  text
,datetime_loaded     timestamp_ntz  default current_timestamp()
);

create  or replace table landing.invoice_line (
invoice_line_id     text
,invoice_id         text
,track_id           text
,unit_price         text
,quantity           text 
,datetime_loaded    timestamp_ntz  default current_timestamp()

);

create  or replace table landing.playlist (
playlist_id         text
,name               text
,datetime_loaded        timestamp_ntz  default current_timestamp()
);

create  or replace table landing.playlist_track (
playlist_id         text
,track_id           text
,datetime_loaded       timestamp_ntz  default current_timestamp()
);

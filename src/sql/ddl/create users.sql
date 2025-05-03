
/* 

Name: create_users.sql
Purpose: Creates users
Comment: - Run as securityadmin
         - Replace <your warehouse>  and <your password>
           with appropriate values

*/
create or replace user chinook_loader
  default_password = <your password>
  default_role = CHINOOK_LOADER_ROLE
  default_warehouse = <your warehouse>
  default_namespace = CHINOOK
  disabled = false
  must_change_password = false
  comment = 'Loads raw data into chinook.landing';


create or replace user dbt_user
  default_password = <your password>
  default_role = DBT_MODEL_RUNNER_ROLE
  default_warehouse = <your warehouse>
  default_namespace = CHINOOK
  disabled = false
  must_change_password = false
  comment = 'Runs dbt models';


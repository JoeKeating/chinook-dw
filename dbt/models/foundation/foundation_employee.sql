with landing_employee as (
    select  employee_id     
            ,last_name      
            ,first_name     
            ,title          
            ,reports_to     
            ,birth_date     
            ,hire_date      
            ,address        
            ,city           
            ,state          
            ,country        
            ,postal_code    
            ,phone          
            ,fax            
            ,email          
            ,datetime_loaded
    from {{ source('landing', 'employee')}}
),
transformed_employee as (
    select  {{ generate_sk('employee',['employee_id']) }} as employee_sk
            ,cast(employee_id as bigint) as employee_source_id     
            ,cast(last_name as varchar(50)) as employee_last_name   
            ,cast(first_name as varchar(50)) as employee_first_name
            ,cast(title as varchar(50)) as employee_title        
            ,cast(reports_to as varchar(255)) as employee_reports_to  
            ,cast(birth_date as date) as employee_birth_date  
            ,cast(hire_date  as date) as employee_hire_date    
            ,cast(address as varchar(255)) as employee_address       
            ,cast(city as varchar(50)) as employee_city           
            ,cast(state as varchar(50)) as employee_state           
            ,cast(country as varchar(50)) as employee_country        
            ,cast(postal_code as varchar(50)) as employee_postal_code    
            ,cast(phone as varchar(50)) as employee_phone        
            ,cast(fax as varchar(50)) as employee_fax           
            ,cast(email as varchar(255)) as employee_email          
            ,datetime_loaded as source_data_loaded_datetime
    from landing_employee
            )

    select  employee_sk
            ,employee_source_id     
            ,employee_last_name   
            ,employee_first_name
            ,employee_title        
            ,employee_reports_to  
            ,employee_birth_date  
            ,employee_hire_date    
            ,employee_address       
            ,employee_city           
            ,employee_state           
            ,employee_country        
            ,employee_postal_code    
            ,employee_phone        
            ,employee_fax           
            ,employee_email          
            ,source_data_loaded_datetime
    from    transformed_employee
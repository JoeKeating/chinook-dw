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
)
,
base_employee as (
        select  {{ generate_sk('employee',['employee_id']) }} as employee_sk
                ,cast(employee_id as bigint) as employee_source_id     
                ,cast(last_name as varchar(50)) as employee_last_name   
                ,cast(first_name as varchar(50)) as employee_first_name
                ,cast(title as varchar(50)) as employee_title        
                ,cast(reports_to as bigint) as reports_to_employee_source_id
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
                ,{{ generate_hashdiff('customer', [  'employee_last_name'
                                                        ,'employee_first_name'
                                                        ,'employee_title'
                                                        ,'reports_to_employee_source_id'
                                                        ,'employee_birth_date'
                                                        ,'employee_hire_date'
                                                        ,'employee_address'
                                                        ,'employee_city'
                                                        ,'employee_state'
                                                        ,'employee_country'
                                                        ,'employee_postal_code '
                                                        ,'employee_phone' 
                                                        ,'employee_fax' 
                                                        ,'employee_email'    
                                                        ]) }} as employee_hashdiff         
                ,datetime_loaded as source_data_loaded_datetime
        from landing_employee
),
transformed_employee as (
        select  e.employee_sk
                ,e.employee_source_id     
                ,e.employee_last_name   
                ,e.employee_first_name
                ,e.employee_title        
                ,e.reports_to_employee_source_id 
                ,m.employee_sk as reports_to_employee_sk
                ,e.employee_birth_date  
                ,e.employee_hire_date    
                ,e.employee_address       
                ,e.employee_city           
                ,e.employee_state           
                ,e.employee_country        
                ,e.employee_postal_code    
                ,e.employee_phone        
                ,e.employee_fax           
                ,e.employee_email
                ,e.employee_hashdiff          
                ,e.source_data_loaded_datetime
        from    base_employee e
                left outer join base_employee m
        on      e.reports_to_employee_source_id =
                m.employee_source_id 
)       
        select  employee_sk
                ,employee_source_id     
                ,employee_last_name   
                ,employee_first_name
                ,employee_title        
                ,reports_to_employee_source_id 
                ,reports_to_employee_sk 
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
                ,employee_hashdiff          
                ,source_data_loaded_datetime
        from    transformed_employee
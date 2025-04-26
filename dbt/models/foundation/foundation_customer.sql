with landing_customer as (
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
    from {{ source('landing', 'customer')}} 

)


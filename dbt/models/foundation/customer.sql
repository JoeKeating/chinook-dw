with landing_customer as (
        select  customer_id     
                ,first_name     
                ,last_name      
                ,company        
                ,address        
                ,city           
                ,state          
                ,country        
                ,postal_code    
                ,phone          
                ,fax            
                ,email          
                ,support_rep_id   
                ,datetime_loaded  
    from {{ source('landing', 'customer')}} 
),
employee_keys as (
        select  employee_sk
                ,employee_source_id
        from    {{ ref('employee') }}
),
joined_customer as (
        select  c.customer_id     
                ,c.first_name     
                ,c.last_name      
                ,c.company        
                ,c.address        
                ,c.city           
                ,c.state          
                ,c.country        
                ,c.postal_code    
                ,c.phone          
                ,c.fax            
                ,c.email 
                ,ek.employee_source_id         
                ,ek.employee_sk  
                ,c.datetime_loaded  
        from    landing_customer c 
                join employee_keys ek
        on      c.support_rep_id =
                ek.employee_source_id


),
transformed_customer as (
        select   {{ generate_sk('customer',['customer_id']) }} as customer_sk
                ,cast(customer_id  as bigint) as customer_source_id  
                ,cast(first_name as varchar(50)) as customer_first_name  
                ,cast(last_name as varchar(50)) as customer_last_name     
                ,cast(company as varchar(255))  as customer_company        
                ,cast(address as varchar(255)) as customer_address        
                ,cast(city as varchar(50)) as customer_city           
                ,cast(state  as varchar(50))    as customer_state      
                ,cast(country   as varchar(50))  as customer_country    
                ,cast(postal_code   as varchar(50)) as customer_postal_code
                ,cast(phone  as varchar(50)) as customer_phone       
                ,cast(fax  as varchar(50))  as customer_fax         
                ,cast(email   as varchar(50))  as customer_email  
                ,employee_source_id as customer_support_rep_source_id    
                ,employee_sk as customer_support_rep_sk
                ,{{ generate_hashdiff('customer', ['customer_first_name'
                                                 ,'customer_last_name'
                                                 ,'customer_company'
                                                 ,'customer_address'
                                                 ,'customer_city'
                                                 ,'customer_state'
                                                 ,'customer_postal_code'
                                                 ,'customer_phone'
                                                 ,'customer_email'
                                                 ,'customer_fax'
                                                 ,'employee_source_id'   
                                                 ]) }} as customer_hashdiff
                ,datetime_loaded   as source_data_loaded_datetime
        from joined_customer
)
        select   customer_sk
                ,customer_source_id  
                ,customer_first_name  
                ,customer_last_name     
                ,customer_company        
                ,customer_address        
                ,customer_city           
                ,customer_state      
                ,customer_country    
                ,customer_postal_code
                ,customer_phone       
                ,customer_fax         
                ,customer_email 
                ,customer_support_rep_source_id    
                ,customer_support_rep_sk
                ,customer_hashdiff
                ,source_data_loaded_datetime
        from    transformed_customer


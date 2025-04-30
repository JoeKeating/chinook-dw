with landing_invoice as (
    select  invoice_id          
            ,customer_id        
            ,invoice_date       
            ,billing_address    
            ,billing_city       
            ,billing_state      
            ,billing_country    
            ,billing_postal_code    
            ,total                  
            ,datetime_loaded 
    from {{ source('landing', 'invoice') }}
),
customer_keys as (
    select  customer_source_id,
            customer_sk
    from    {{ref('customer')}}
),
joined_invoice as (
     select  i.invoice_id      
            ,i.customer_id 
            ,ck.customer_sk       
            ,i.invoice_date       
            ,i.billing_address    
            ,i.billing_city       
            ,i.billing_state      
            ,i.billing_country    
            ,i.billing_postal_code    
            ,i.total                  
            ,datetime_loaded 
    from    landing_invoice i
            join customer_keys ck
    on      i.customer_id =
            ck.customer_source_id
),
transformed_invoice as (
    select  {{ generate_sk('invoice', ['invoice_id']) }} as invoice_sk
            ,cast(invoice_id  as bigint) as invoice_source_id    
            ,cast(customer_id as bigint) as customer_source_id
            ,customer_sk       
            ,cast(invoice_date as date) as invoice_date       
            ,cast(billing_address  as varchar(50)) as invoice_billing_address  
            ,cast(billing_city  as varchar(50)) as  invoice_billing_city      
            ,cast(billing_state  as varchar(50)) as  invoice_billing_state     
            ,cast(billing_country  as varchar(50)) as   invoice_billing_country  
            ,cast(billing_postal_code  as varchar(50)) as  invoice_billing_postal_code   
            ,cast(total as number(10,2)) as invoice_total
            , {{ generate_hashdiff('track', ['customer_source_id'
                                            ,'invoice_date '
                                            ,'invoice_billing_address'
                                            ,'invoice_billing_city'
                                            ,'invoice_billing_state'
                                            ,'invoice_billing_country'
                                            ,'invoice_billing_postal_code'
                                            ,'invoice_billing_postal_code'
                                            ,'invoice_total']) }} as invoice_hashdiff                  
            ,datetime_loaded  as source_data_loaded_datetime
    from    joined_invoice
)

select  invoice_sk
        ,invoice_source_id    
        ,customer_source_id
        ,customer_sk       
        ,invoice_date       
        ,invoice_billing_address  
        ,invoice_billing_city      
        ,invoice_billing_state     
        ,invoice_billing_country  
        ,invoice_billing_postal_code   
        ,invoice_total
        ,invoice_hashdiff                  
        ,source_data_loaded_datetime
from    transformed_invoice
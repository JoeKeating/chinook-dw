with landing_invoice_line as (
    select  invoice_line_id     
            ,invoice_id         
            ,track_id           
            ,unit_price         
            ,quantity            
            ,datetime_loaded 
    from {{ source('landing', 'invoice_line') }}
),
invoice_keys as(
    select  invoice_source_id
            ,invoice_sk
    from    {{ ref('invoice')}}
),
track_keys  as (
    select  track_source_id
            ,track_sk
    from    {{ ref('track') }}
),
joined_invoice_line as (
    select  il.invoice_line_id
            ,ik.invoice_sk
            ,il.invoice_id
            ,tk.track_sk
            ,il.track_id
            ,il.unit_price
            ,il.quantity 
            ,il.datetime_loaded 
    from    landing_invoice_line il
    join    track_keys tk 
    on      il.track_id =
            tk.track_source_id
    join    invoice_keys ik 
    on      il.invoice_id =
            ik.invoice_source_id  
),
transformed_invoice_line as (
    select  {{ generate_sk('invoice_line', ['invoice_line_id']) }} as invoice_line_sk
            ,cast(invoice_line_id as bigint) as invoice_line_source_id
            ,invoice_sk
            ,cast(invoice_id as bigint) as invoice_source_id
            ,track_sk
            ,cast(track_id as bigint) as track_source_id
            ,cast(unit_price as number(10,2)) as invoice_line_unit_price
            ,cast(quantity as bigint) as invoice_line_quantity
            ,{{ generate_hashdiff('invoice_line', ['invoice_line_source_id'
                                            ,'invoice_source_id'
                                            ,'track_source_id'
                                            ,'invoice_line_unit_price'
                                            ,'invoice_line_quantity'
                                            ]) }} as invoice_line_hashdiff   
            ,datetime_loaded   as source_data_loaded_datetime
    from    joined_invoice_line
)

select  invoice_line_sk
        ,invoice_line_source_id
        ,invoice_sk
        ,invoice_source_id
        ,track_sk
        ,track_source_id
        ,invoice_line_unit_price
        ,invoice_line_quantity
        ,invoice_line_hashdiff   
        ,source_data_loaded_datetime
from    transformed_invoice_line
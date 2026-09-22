select
    id                          as customer_id,
    initcap(first_name)         as first_name,
    initcap(last_name)          as last_name,
    lower(email)                as email,
    cast(created_at as date)    as created_at
from {{ source('raw', 'raw_customers') }}

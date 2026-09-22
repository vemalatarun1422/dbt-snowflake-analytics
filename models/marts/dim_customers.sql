with orders as (
    select * from {{ ref('fct_orders') }}
    where status != 'returned'
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.created_at,
    min(o.order_date)                    as first_order_date,
    max(o.order_date)                    as most_recent_order_date,
    count(o.order_id)                    as number_of_orders,
    coalesce(sum(o.order_amount), 0)     as lifetime_value
from {{ ref('stg_customers') }} c
left join orders o using (customer_id)
group by 1, 2, 3, 4, 5

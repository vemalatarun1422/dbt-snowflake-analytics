{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

with orders as (
    select * from {{ ref('stg_orders') }}
    {% if is_incremental() %}
    where order_date >= (select dateadd(day, -3, max(order_date)) from {{ this }})
    {% endif %}
),

payments as (
    select
        order_id,
        sum(amount)                                                     as order_amount,
        sum(case when payment_method = 'gift_card' then amount else 0 end) as gift_card_amount,
        count(*)                                                        as payment_count
    from {{ ref('stg_payments') }}
    group by order_id
)

select
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    coalesce(p.order_amount, 0)      as order_amount,
    coalesce(p.gift_card_amount, 0)  as gift_card_amount,
    coalesce(p.payment_count, 0)     as payment_count,
    current_timestamp()              as _loaded_at
from orders o
left join payments p using (order_id)

select
    id                                          as payment_id,
    order_id,
    lower(payment_method)                       as payment_method,
    {{ cents_to_dollars('amount_cents') }}      as amount
from {{ source('raw', 'raw_payments') }}

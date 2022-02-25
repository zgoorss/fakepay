# WELCOME IN FAKEPAY APP

This API let you buy a subscription for a chosen plan via Fakepay payment system.

## Setup

- bundle
- rake db:migrate
- rake db:seed to seed plans to DB
- add a master.key file to /config path with code: **CODE SENT IN EMAIL**
- rails s

## Models

### Customers

- `name`: string
- `address`: string
- `zip_code`: string

There is an unique index on all above fields.

### Payments

- `subscription_id` - belongs to payment
- `token`: encrypted string (it's special token that allows us to renew a subscription automatically)
- `amount`: decimal

There is an index on subscription_id.

### Plans

- `name`: string
- `price_in_cents`: decimal

### Subscriptions

- `plan_id` - belongs to plan
- `customer_id` - belongs to customer
- `expires_at`: date - a date when a subscription get expired
- `active`: boolean - it's a flag that subscription is active or not

There is an unique index on plan_id and subscription_id.
There is an index on plan_id.
There is an index on customer_id.

## API

### Request

If you want to buy a subscription, call the following request with body:

*POST /api/v1/subscriptions*

```json
{
  "plan_id": 1,
  "customer_id": 1,
  "customer": {
    "name": "",
    "address": "",
    "zip_code": ""
  },
  "payment": {
    "card_number": "",
    "expiration_date": "",
    "cvv": "",
    "zip_code": ""
  }
}
```

If you have customer_id (it's received in response), you do not have to make a request with `customer` key. If you do not have ID, you have to add `customer` key.

The `expiration_date` must be in the following format: 02/2022.

### Response

If your request will be processed correctly, you receive the following data:

**Status: 201**

```json
{
    "subscription": {
        "id": 27,
        "plan_id": 5,
        "customer_id": 15,
        "expires_at": "2022-03-25T00:00:00.000Z",
        "active": true,
        "created_at": "2022-02-25T15:30:04.865Z",
        "updated_at": "2022-02-25T15:30:04.865Z"
    },
    "customer": {
        "id": 15,
        "name": "test3",
        "address": "test",
        "zip_code": "000",
        "created_at": "2022-02-25T15:30:04.397Z",
        "updated_at": "2022-02-25T15:30:04.397Z"
    }
}
```

### Errors

If something go wrong, you will receive the following error message:

```json
{
    "title": "Subscription already exists for the customer",
    "error": "subscription_exists"
}
```

or

```json
{
    "title": "Invalid credit card number",
    "error": "invalid_credit_card_number"
}
```

#### Potential errors:

**Status: 400**
- `bad_request`: Bad request

**Status: 404**
- `record_not_found`: Record not found

**Status: 422**
- `invalid_credit_card_number`: Invalid credit card number
- `insufficient_funds`: Insufficient funds
- `cvv_failure`: CVV failure
- `expired_card`: Expired card
- `invalid_zip_code`: Invalid zip code
- `invalid_purchase_amount`: Invalid purchase amount
- `invalid_token`: Invalid token
- `invalid_params`: Invalid params: cannot specify both token andother credit card params
- `record_invalid`: Invalid record
- `subscription_exists`: Subscription already exists for the customer

**Status: 503**
- `service_unavailable`: Service Unavailable

## CRON

There is a possibility to set the following rake tasks in CRON:

### `rake subscriptions:deactivate_expired`

The rake task deactivates all subscriptions that got expired.

### `rake subscriptions:renew`

The rake task tries to make a payment for the subscription. It gets a token from last payment and tries to make a new one. If everything goes well, it adds the payment to the subscription, activates them and extends `expires_at` by 1 month.

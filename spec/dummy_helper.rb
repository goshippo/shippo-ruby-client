DUMMY_BATCH = {
    "default_carrier_account": DEFAULT_CARRIER_ACCOUNT,
    "default_servicelevel_token": "usps_priority",
    "label_filetype": "ZPLII",
    "metadata": "BATCH #170",
}

DUMMY_SHIPMENT = {
    "address_from": {
        "name": "Simon Says",
        "company": "",
        "street1": "965 Mission St",
        "street2": "Ste 201",
        "city": "San Francisco",
        "state": "CA",
        "zip": "94103",
        "country": "US",
        "phone": "4151234567",
        "email": "hippo@goshippo.com"
    },
    "address_to": {
        "name": "Who Says",
        "company": "",
        "street1": "400 Simon St",
        "street_no": "",
        "street2": "Apt 123",
        "city": "San Francisco",
        "state": "CA",
        "zip": "94102",
        "country": "US",
        "phone": "4151234567",
        "email": "hippo@goshippo.com",
        "metadata": ""
    },
    "parcels": [{
        "length": "5",
        "width": "5",
        "height": "5",
        "distance_unit": "in",
        "weight": "2",
        "mass_unit": "oz",
        "template": "",
        "metadata": "Customer ID 123456"
    }],
    "extra": {
        "reference_1": "REF1 - Simon",
        "reference_2": "REF2 - Says",
    },
    "metadata": ""
}

DUMMY_SHIPMENT_2 = {
    "address_from": {
        "name": "Amazon Fulfillment Services",
        "company": "Returns Departments",
        "street1": "400 Simon St",
        "street2": "123",
        "city": "San Francisco",
        "state": "CA",
        "zip": "94102",
        "country": "US",
        "phone": "4151234567",
        "email": "hippo@goshippo.com"
    },
    "address_to": {
        "name": "First Last",
        "company": "",
        "street1": "965 Mission St",
        "street2": "#123",
        "city": "San Francisco",
        "state": "CA",
        "zip": "94103",
        "country": "US",
        "phone": "4151234567",
        "email": "hippo@goshippo.com",
    },
    "parcels": [{
        "length": "10",
        "width": "15",
        "height": "10",
        "distance_unit": "in",
        "weight": "15",
        "mass_unit": "oz",
        "metadata": ""
    }],
    "extra": {
      "reference_1": "REF1 - Simon",
      "reference_2": "REF2 - Says",
    }
}

DUMMY_ADDRESS_US = {
    "name": "Simon Says",
    "company": "",
    "street1": "965 Mission St",
    "street2": "Ste 201",
    "city": "San Francisco",
    "state": "CA",
    "zip": "94103",
    "country": "US",
    "phone": "4151234567",
    "email": "hippo@goshippo.com"
}

DUMMY_ORDER = {
    "total_tax": "0.00",
    "from_address": {
        "city": "San Francisco",
        "state": "CA",
        "object_purpose": "PURCHASE",
        "name": "lucas work",
        "zip": "94103",
        "country": "US",
        "street2": "unit 200",
        "street1": "731 Market ST",
        "company": "Shippo",
        "phone": "(985) 580-1234"
    },
    "to_address": {
        "object_purpose": "PURCHASE",
        "name": "Mrs. Hippo",
        "company": "Shippo & Co",
        "street1": "156 Haviland Rd",
        "street2": "",
        "city": "Ridgefield",
        "state": "CT",
        "zip": "06877-2822",
        "country": "US",
        "phone": "+1 555 341 9393",
        "email": "support@goshippo.com",
        "metadata": "Customer ID 123456"
    },
    "shipping_method": nil,
    "weight": 0,
    "shop_app": "Shippo",
    "currency": "USD",
    "shipping_cost_currency": "USD",
    "shipping_cost": nil,
    "subtotal_price": "0",
    "total_price": "0",
    "items": [
        {
            "total_amount": "10.45"
        }
    ],
    "order_status": "PAID",
    "hidden": false,
    "order_number": "LOREM #1",
    "weight_unit": "kg",
    "placed_at": "2021-11-12T23:59:59"
}

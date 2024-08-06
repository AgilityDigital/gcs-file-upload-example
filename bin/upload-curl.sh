#!/bin/bash
GOOGLE_APPLICATION_CREDENTIALS=.credentials.json

# Set the customer ID
CUSTOMER_ID="12345"

# Set the date
DATE=$(date +%Y-%m-%d)

# Set the object location
OBJECT_LOCATION="test.json"

curl -X POST --data-binary @test.json \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json" \
    "https://storage.googleapis.com/upload/storage/v1/b/socs-sbx/o?uploadType=media&name=offline/crm-data/${CUSTOMER_ID}/${DATE}"

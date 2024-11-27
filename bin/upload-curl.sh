#!/bin/bash
GOOGLE_APPLICATION_CREDENTIALS=.credentials.json

# Set the customer ID
CUSTOMER_ID="12345"

BUCKET_NAME="agility-sandbox"

# Set the date
DATE=$(date +%Y-%m-%d)

# Set the object location
OBJECT_LOCATION="example.json"

curl -X POST --data-binary @test.json \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json" \
    "https://storage.googleapis.com/upload/storage/v1/b/${BUCKET_NAME}/o?uploadType=media&name=offline/conversions/${DATE}"

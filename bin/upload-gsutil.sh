#1bin/bash
GOOGLE_APPLICATION_CREDENTIALS=.credentials.json

# Set the customer ID
CUSTOMER_ID="12345"

# Set the bucket name
BUCKET_NAME="agility-sandbox"

# Set the date
DATE=$(date +%Y-%m-%d)

# Set the object location
OBJECT_LOCATION="example.json"

gsutil cp ${OBJECT_LOCATION} gs://${BUCKET_NAME}/offline/conversions/${DATE}

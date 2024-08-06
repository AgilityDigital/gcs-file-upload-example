#1bin/bash
GOOGLE_APPLICATION_CREDENTIALS=.credentials.json

# Set the customer ID
CUSTOMER_ID="12345"

# Set the date
DATE=$(date +%Y-%m-%d)

# Set the object location
OBJECT_LOCATION="test.json"

gsutil cp ${OBJECT_LOCATION} gs://socs-sbx/offline/crm-data/${CUSTOMER_ID}/${DATE}

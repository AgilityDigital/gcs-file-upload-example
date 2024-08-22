from google.cloud import storage
import sys
from datetime import datetime

# run this command to execute the script
# GOOGLE_APPLICATION_CREDENTIALS=.credentials.json python3 src/upload.py test.json .credentials.json 123456

def upload_blob(bucket_name, source_file_name, credentials, destination_blob_name):
    """Uploads a file to the bucket.

    from https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-client-libraries

    """

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    print(
        f"File {source_file_name} uploaded to {destination_blob_name}."
    )

source_file_name = sys.argv[1] # "local/path/to/file"
key_file = sys.argv[2] # "path/to/keyfile.json"
customer_id = sys.argv[3] # "customer-id"
bucket_name = "socs-sbx"
    
print(f"Uploading {source_file_name} to {customer_id} bucket")

object_name = "offline/{}/crm-data/{}".format(customer_id, datetime.now().strftime("%Y-%m-%d"))
upload_blob(bucket_name, source_file_name, creds, object_name)

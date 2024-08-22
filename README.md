# GCS file upload Demo

This is a simple demo to upload a file to Google Cloud Storage (GCS) using Python, gsutil and the GCS API. The demo is based on the [official GCS documentation](https://cloud.google.com/storage/docs/). The credentials needed are a key file in JSON format, which can be obtained from the Google Cloud Console.

## Requirements

In order to make the call you will need to have a service account created and an access key attached to it. The key should be in JSON format. The key should be generated once and rotated with some frequency.

Here we are requiring a specific bucket and object path when you upload the file. The bucket name is `agility-digital` and the object path is `offline/${CUSTOMER_ID}/crm-data/${DATE}`. The `CUSTOMER_ID` and `DATE` are parameters that you will need to pass to the script. The `DATE` should be in the format `YYYY-MM-DD`. The `CUSTOMER_ID` is a string that identifies you in our system. We will provide this information to you when we provide the key file.

### Payload

The json payload should be in the following format:

```json
{
	"Metadata": {
		"ClientId": "123456", // Same as the customer id
		"SentTimeStampUTC": "2023-03-23T22:11:13.2311903Z"
	}
	"Milestones": [ 
		{
			"Email": "example@email.com",
			"Phone": "+1(801)555-1234",
			"FullName": "John Doe", // Optional
			"Address": { // Optional of the user
				"City": "Salt Lake City",
				"State": "UT",
				"Country": "USA",
				"Zip": "84101",
				"Street": "123 Main St"
			},
			"TimestampUtc": "2023-03-23T22:11:13.2311903Z", // time of milestone
			"OrderID": "123456",
			"Quantity": 1, 
			"ConversionType": "",

            // optional fields
			"Region": "UT", 
			"City": "Salt Lake City",
			"MerchantID": "123456",
			"ProductID": "123456",
			"ProductPrice": 123.45, 
		}
	]
}
```

### Authentication

once you have the key file, you can set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the path of the key file. This will allow the application to authenticate with GCS.

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/keyfile.json"
```

### Curl

We are following these steps from the [official GCS documentation](https://cloud.google.com/storage/docs/uploading-objects#uploading-an-object) to make the call using curl. This example is for a single file, but you can use the same method to do a multipart upload for larger files. The recommended max file size for a single upload is ~1GB

```bash
curl -X POST --data-binary @test.json \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json" \
    "https://storage.googleapis.com/upload/storage/v1/b/agility-digital/o?uploadType=media&name=offline/${CUSTOMER_ID}/crm-data/${DATE}"
```

To see the runable script, check the [`upload.sh` file.](/bin/upload-curl.sh)


### Python

We are following the steps from the [official GCS documentation](https://cloud.google.com/storage/docs/uploading-objects#uploading-an-object) to make the call using Python. This example is for a single file, but you can use the same method to do a multipart upload for larger files. The recommended max file size for a single upload is ~1GB. You will need to install the `google-cloud-storage` package.


```python
from google.cloud import storage
import sys
from datetime import datetime

def upload_blob(bucket_name, source_file_name, credentials, destination_blob_name):
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

source_file_name = sys.argv[1] # "local/path/to/file"
key_file = sys.argv[2] # "path/to/keyfile.json"
customer_id = sys.argv[3] # "customer-id"
bucket_name = "agility-digital"
    
object_name = "offline/{}/crm-data/{}".format(customer_id, datetime.now().strftime("%Y-%m-%d"))
upload_blob(bucket_name, source_file_name, creds, object_name)
```

To see the runable script, check the [`upload.py` file.](/src/upload.py)
Use this command to run the script:
```bash
GOOGLE_APPLICATION_CREDENTIALS=.credentials.json python3 src/upload.py test.json .credentials.json 123456
```

### gsutil

gsutil is a command line tool that allows you to interact with GCS. You can use it to upload files, download files, list files, etc. It is installed via the Google Cloud SDK. You can use the following command to upload a file to GCS:

```bash
gsutil cp ${OBJECT_LOCATION} gs://agility-digital/offline/${CUSTOMER_ID}/crm-data/${DATE}
```

To see the runable script, check the [`upload-gsutil.sh` file.](/bin/upload-gsutil.sh)

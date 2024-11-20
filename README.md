# GCS file upload Demo

This is a simple demo to upload a file to Google Cloud Storage (GCS) using Python, gsutil and the GCS API. The demo is based on the [official GCS documentation](https://cloud.google.com/storage/docs/). The credentials needed are a key file in JSON format, which can be obtained from the Google Cloud Console. This is up to date as of 2024-09-09.

## Requirements

In order to make the call you will need to have a service account created and an access key attached to it. The key should be in JSON format. The key should be generated once and rotated with some frequency.

Here we are requiring a specific bucket and object path when you upload the file. The bucket name is `agility-digital` and the object path is `offline/${CUSTOMER_ID}/crm-data/${DATE}`. The `CUSTOMER_ID` and `DATE` are parameters that you will need to pass to the script. The `DATE` should be in the format `YYYY-MM-DD`. The `CUSTOMER_ID` is a string that identifies you in our system. We will provide this information to you when we provide the key file.

### Payload

The files you upload to the bucket should be JSON in format following the format below. The size limit in GCS is [5 TB](https://support.google.com/a/answer/172541?hl=en#:~:text=You%20can%20upload%20and%20synchronize,GB%20can't%20be%20copied.), but please we ask that you keep the files under 500GB and that the files contain not more data than what pertains to the date if the folder. If you choose to partition the files further you can do that at your disgression. The json payload should be in the following format:

Payload formatings are as follows:

| Field | Description | Type | Required |
| --- | --- | --- | --- |
| Metadata | Contains the metadata for the file | Object | Yes |
| Milestones | Contains the milestones events that correspond to a conversion. There must be at least one conversion per file | Array | Yes |

| Metadata Fields | Description | Type | Required |
| --- | --- | --- | --- |
| ClientId | The unique identifier for the client. Provided to you by Agility. Use Sandbox for testing | String | Yes |
| SentTimeStampUTC | The time the file was sent in UTC. Use the Format `2023-03-23T22:11:13.2311903Z` | String | Yes |

| Milestone Fields | Description | Type | Required |
| --- | --- | --- | --- |
| Email | The email of the user | String | If phone or address provided |
| Phone | The phone number of the user | String | If email or address provided |
| FullName | The full name of the user | String | No |
| Address | The address of the user | Object | If email and phone not provided |
| TimestampUtc | The time of the milestone in UTC. Use the Format `2023-03-23T22:11:13.2311903Z` | String | Yes |
| ConversionType | The type of conversion. Use the preset list of offline conversion types. The list is set during the onboarding process | String | Yes |
| ConversionKey | The unique identifier for the milestone. It could be an orderID, transactionID, SKU, or inboundCallID | String | Yes |
| ProductID | The unique identifier for the product that was purchased | String | Yes |
| Quantity | The number of items purchased | Integer | No |
| Value | The total value of the transaction | Float | No |
| CustomFields | Additional fields that you can use to pass additional information about the milestone | Object | No |

| Address Fields | Description | Type | Required |
| --- | --- | --- | --- |
| City | The city of the user | String | Yes |
| State | The state of the user | String | Yes |
| Country | The country of the user | String | Yes |
| Zip | The zip code of the user | String | Yes |
| Street | The street address of the user | String | Yes |

| CustomFields Fields | Description | Type | Required |
| --- | --- | --- | --- |
| TrackingData2 | Determined during onboarding | String | No |
| TrackingData3 | Determined during onboarding | String | No |
| TrackingData4 | Determined during onboarding | String | No |
| TrackingData5 | Determined during onboarding | String | No |
| TrackingData6 | Determined during onboarding | String | No |
| TrackingData7 | Determined during onboarding | String | No |
| TrackingData8 | Determined during onboarding | String | No |
| TrackingData9 | Determined during onboarding | String | No |

```json
{
{
	"Metadata": {
		"ClientId": "123456", // Same as the customer_id
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
			"ConversionType": "phone_offline",
			"ConversionKey": "123456", // TD10
			"ProductID": "123456", //TD1 

            // Optional fields
			"Quantity": 1, 
			"Region": "UT", 
			"City": "Salt Lake City",
            "OrderID": "123456", 
			"MerchantID": "123456",
			"Value": 123.45,
			"CustomFields": {
				"TrackingData2": "CustomValue1", // TD2
				"TrackingData3": "CustomValue2", // TD3
				"TrackingData4": "CustomValue3", // TD4
				"TrackingData5": "CustomValue4", // TD5
				"TrackingData6": "CustomValue5", // TD6
				"TrackingData7": "CustomValue6", // TD7
				"TrackingData8": "CustomValue7", // TD8
				"TrackingData9": "CustomValue8", // TD9
			}
		}
	]
}
```
#### Metadata

You can add multiple milestones to the file. The `Metadata` section is required and contains the `ClientId` and `SentTimeStampUTC` fields. The `Milestones` section is an array of milestones. Each milestone should have the following fields:

The `ClientID` will be provided to you by agility and it links your account to conversion tracking algorithm in The Trade Desk.  This is a string.

`SentTimeStampUTC` is the time that the file was sent to us. It needs to be in one of the following formats: `2006-01-02T15:04:05Z07:00` or `2006-01-02 15:04:05`. This is a string.

#### Required Marketing Fields

* The `ConversionType` is a string value that is selected to best match the kind of event that the milestone is. We have a preset list of offline conversion types that you can choose from, but you will have some additional one determined by your Agility representative. This is a string.
* `ConversionKey` is the unique identifier for your milestone, it could be an orderID, transactionID, SKU, or inboundCallID (it may have been referred to as TD10 in the past).  This is a string.
* The `ProductID` is the unique identifier for the product that was purchased (it may have been referred to as TD1 in the past).  This is a string.
* The `Email` and `Phone` fields are used to identify the user. one of them is required. These are strings.

#### Optional Marketing Fields

* The `Value` field is the total value of the transaction. This is a float value.
* The `Quantity` field is the number of items purchased. This is an integer value.
* The `CustomFields` are optional fields that you can use to pass additional information about the milestone. They are fields that you will have established as part of you onboarding process with your Precision Strategy Consultant. Some of the CustomFields may be duplicated with some standardized fields. This is expected to help us better track certain statistics. These are strings
* The `Region`, `City`, `OrderID`, and `MerchantID` fields are optional fields that you can use to pass additional information about the milestone. These are strings.

### Authentication

Once you have the key file, you can set the environment variable `GOOGLE_APPLICATION_CREDENTIALS` to the path of the key file. This will allow the application to authenticate with GCS.

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

## Testing

We have a sandox bucket you can send your test files to. The path is `agility-digital`. You can use the same path format as the production bucket, but the `CUSTOMER_ID` in the path and the payload should be `sandbox`. This data will not be sent to any of our partners and will be used for testing purposes only.

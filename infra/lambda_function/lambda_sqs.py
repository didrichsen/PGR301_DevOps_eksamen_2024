import base64
import boto3
import json
import random
import os
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

MODEL_ID = "amazon.titan-image-generator-v1"
BUCKET_NAME = os.environ["BUCKET_NAME"]


def lambda_handler(event, context):
    logger.info(f"Event: {json.dumps(event)}")  # Log the incoming event

    # Loop through all SQS records in the event
    for record in event["Records"]:
        logger.info(f"Processing record: {record}")

        # Extract the SQS message body
        prompt = record["body"]
        logger.info(f"Prompt: {prompt}")

        seed = random.randint(0, 2147483647)
        s3_image_path = f"40/images/titan_{seed}.png"
        logger.info(f"Generated image path: {s3_image_path}")

        # Prepare the request for image generation
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 512,
                "width": 512,
                "seed": seed,
            },
        }

        # Invoke the model
        try:
            response = bedrock_client.invoke_model(
                modelId=MODEL_ID,
                body=json.dumps(native_request)
            )
            logger.info(f"Model response: {response}")
        except Exception as e:
            logger.error(f"Error invoking the model: {str(e)}")
            raise e

        model_response = json.loads(response["body"].read())
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload the image to S3
        try:
            s3_client.put_object(Bucket=BUCKET_NAME, Key=s3_image_path, Body=image_data)
            logger.info(f"Successfully uploaded image to s3://{BUCKET_NAME}/{s3_image_path}")
        except Exception as e:
            logger.error(f"Error uploading image to S3: {str(e)}")
            raise e

    return {
        "statusCode": 200,
        "body": json.dumps("")
    }

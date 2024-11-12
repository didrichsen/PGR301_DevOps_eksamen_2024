import base64
import os
import boto3
import json
import random

bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

model_id = "amazon.titan-image-generator-v1"
bucket_name = os.getenv("BUCKET_NAME")
candidate_number = 40

def lambda_handler(event, context):
    try:
        # Extract the prompt from the POST request body
        body = json.loads(event['body']) if event.get('body') else {}
        prompt = body.get('prompt', "Investors, with circus hats, giving money to developers with large smiles")

        seed = random.randint(0, 2147483647)
        s3_image_path = f"{candidate_number}/titan_{seed}.png"

        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 1024,
                "width": 1024,
                "seed": seed,
            }
        }

        response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())

        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Image generated and uploaded successfully',
                'image_path': f"https://{bucket_name}.s3.amazonaws.com/{s3_image_path}"
            })
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Error generating or uploading image',
                'error': str(e)
            })
        }
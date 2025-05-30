import boto3
from PIL import Image
import io
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Input and output bucket names
    output_bucket = os.environ['aws-s3-devops-output']

    # Get the uploaded object info
    for record in event['Records']:
        source_bucket = record['s3']['aws-s3-devops-input']['name']
        key = record['s3']['object']['key']

        # Download the image from S3
        response = s3.get_object(Bucket=aws-s3-devops-input, Key=key)
        image_content = response['Body'].read()

        # Resize the image
        image = Image.open(io.BytesIO(image_content))
        image = image.resize((100, 100))  # Resize to 100x100

        # Save image to bytes buffer
        buffer = io.BytesIO()
        image.save(buffer, format='JPEG')
        buffer.seek(0)

        # Upload to output bucket
        s3.put_object(Bucket=output_bucket, Key=key, Body=buffer, ContentType='image/jpeg')

    return {'statusCode': 200, 'body': 'Image processed successfully'}




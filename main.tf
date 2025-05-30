provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "aws-s3-devops-input" {
  bucket = "aws-s3-devops-input"
}

resource "aws_s3_bucket" "aws-s3-devops-output" {
  bucket = "aws-s3-devops-output"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.hackathon-lambda-execution-role.name
  policy_arn = "arn:aws:iam::539935451710:role/hackathon-lambda-execution-role"
}

resource "aws_lambda_function" "image_processor" {
  function_name = "image-devops"
  role          = aws_iam_role.hackathon-lambda-execution-role.name.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")
  environment {
    variables = {
      OUTPUT_BUCKET = aws_s3_bucket.aws-s3-devops-output.bucket
    }
  }
}

resource "aws_s3_bucket_notification" "input_notification" {
  bucket = aws_s3_bucket.aws-s3-devops-input.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_function.image_processor
  ]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.image-devops
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.aws-s3-devops-input.arn
}

}

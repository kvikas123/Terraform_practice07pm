#create a s3 bucket 
resource "aws_s3_bucket" "name" {
  bucket = "my-lambda-test-bucket-s3vikky"
  tags = {
    Name        = "My lambda bucket"
    Environment = "Dev"
  }
}
#upload code/file  in s3 bucket
resource "aws_s3_bucket_object" "object" {

  bucket = aws_s3_bucket.name.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"

  etag = filemd5("lambda_function.zip")
}

#call the s3 code from lambda



resource "aws_iam_role" "lambda_role_s3" {
  name = "lambda_execution_role_s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role_s3.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "my_lambda_s3" {
  function_name = "my_lambda_function_s3"
  role          =  aws_iam_role.lambda_role_s3.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 900
  memory_size   = 128

  #filename         = "lambda_function.zip"  # Ensure this file exists
  #source_code_hash = filebase64sha256("lambda_function.zip")

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

#This hash is a checksum that triggers a deployment.

s3_bucket = aws_s3_bucket.name.bucket
s3_key    = aws_s3_bucket_object.object.key

}
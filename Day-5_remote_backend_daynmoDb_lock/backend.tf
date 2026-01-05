terraform {
backend "s3" {
 bucket ="vikkydynmodbs3bucket"
key="Day-5/terraform.tfstate"
region="us-east-1"
#Enable S3 native locking
#use lockfile=true
#The dynamoDb argument no loner needed
dynamodb_table = "terrafrom-state-lock-dynmo"
}
}


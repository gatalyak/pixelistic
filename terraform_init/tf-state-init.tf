
provider "aws" {
  region = "eu-central-1"
  access_key = ""
  secret_key = ""
}



# terraform state file setup
# create an S3 bucket to store the state file in

resource "aws_s3_bucket" "yg-pixelistic-terraformstate" {
    bucket = "yg-pixelistic-terraformstate"
 
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    region     = "eu-central-1"

    tags {
      ita_group = "Lv-517"
      Name = "yg-pixelistic-terraformstate"
    }      
}

resource "aws_dynamodb_table" "yg-pixelistic-terraform_locks" {
  name         = "yg-pixelistic-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  region       = "eu-central-1"
  attribute {
    name = "LockID"
    type = "S"
  }
    tags {
      ita_group = "Lv-517"
      Name = "yg-pixelistic-terraform-locks"
    }      


}
terraform {
 backend "s3" {
   encrypt = true
   bucket  = "yg-pixelistic-terraformstate"
   region  = "eu-central-1"
   key     = "terraformstate/key"
   dynamodb_table = "yg-pixelistic-terraform-locks"

 }
}

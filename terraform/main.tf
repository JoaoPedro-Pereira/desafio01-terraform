terraform {
  required_version = ">= 1.15.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configuração do Provider para apontar para o LocalStack
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://s3.localhost.localstack.cloud:4566"
  }
}

# Criação do Bucket S3
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "desafio-01"
}

# Configuração de acesso público ao bucket
resource "aws_s3_bucket_public_access_block" "frontend_bucket" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política de permissão pública de leitura dos objetos
resource "aws_s3_bucket_policy" "public_read_policy" {
  depends_on = [
    aws_s3_bucket_public_access_block.frontend_bucket
  ]

  bucket = aws_s3_bucket.frontend_bucket.id
  policy = data.aws_iam_policy_document.public_read_anonymous.json
}

data "aws_iam_policy_document" "public_read_anonymous" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.frontend_bucket.arn}/*"
    ]
  }
}

# Configuração de hospedagem de site estático
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Upload do index.html
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.frontend_bucket.id
  key          = "index.html"
  source       = "../index.html"
  content_type = "text/html"
  etag         = filemd5("../index.html")
}

# Upload do style.css
resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.frontend_bucket.id
  key          = "style.css"
  source       = "../style.css"
  content_type = "text/css"
  etag         = filemd5("../style.css")
}

# Upload do script.js
resource "aws_s3_object" "script_js" {
  bucket       = aws_s3_bucket.frontend_bucket.id
  key          = "script.js"
  source       = "../script.js"
  content_type = "application/javascript"
  etag         = filemd5("../script.js")
}

# URL do website
output "website_url" {
  description = "The endpoint URL for the static website"
  value       = "http://${aws_s3_bucket.frontend_bucket.id}.s3-website.localhost.localstack.cloud:4566"
}
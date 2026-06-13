resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
  
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 30 days"
        selection    = {
          tagStatus     = "any"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 30
        }
        action       = {
          type = "expire"
        }
      }
    ]
  })
  
}
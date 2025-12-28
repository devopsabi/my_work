# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}

# IAM Policy for ECR and Logging
resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecr:GetAuthorizationToken"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["ecr:BatchCheckLayerAvailability", "ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:PutImage", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart", "ecr:CompleteLayerUpload"]
        Effect   = "Allow"
        Resource = "arn:aws:ecr:region:account-id:repository/your-repo-name"
      },
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}


# CodeBuild Project

resource "aws_codebuild_project" "docker_build" {
  name          = "docker-to-ecr-build"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true # REQUIRED for Docker-in-Docker

    environment_variable {
      name  = "REPOSITORY_URI"
      value = "xxxxxxxxxxx.dkr.ecr.region.amazonaws.com/aa-docker-images"
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  source {
    type      = "S3" # or CODECOMMIT / S3
    location  = "aa-docker-images/webapp.zip"
    buildspec = "buildspec.yml"
  }
}

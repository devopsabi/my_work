resource "aws_iam_policy" "codepipeline_ecr_policy" {
  name        = "codepipeline-ecr-policy"
  description = "Allow CodePipeline to describe ECR images"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "arn:aws:ecr:us-east-1:xxxxxxxxxxx:repository/aa-docker-images"
      }
    ]
  })
}

resource "aws_iam_policy" "codepipeline_s3_policy" {
  name        = "codepipeline-s3-policy"
  description = "Allow CodePipeline to put and get objects from artifact bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::aa-docker-images/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::aa-docker-images"
      }
    ]
  })
}


# 1. S3 Bucket for Pipeline Artifacts
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "aa-ecs-pipeline"
}

# 2. IAM Role for CodePipeline
resource "aws_iam_role" "pipeline_role" {
  name = "ecs-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_ecr_attach" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_ecr_policy.arn
}



resource "aws_iam_role_policy_attachment" "codepipeline_s3_attach" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_s3_policy.arn
}

# 3. CodePipeline Definition
resource "aws_codepipeline" "ecs_pipeline" {
  name     = "aa-docker-images"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  # SOURCE: Monitor ECR
  stage {
    name = "Source"
    action {
      name             = "ImageSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = "aa-docker-images"
        ImageTag       = "latest"
      }
    }
  }

  # DEPLOY: Update ECS
  stage {
    name = "Deploy"
    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["source_output"]
      version         = "1"

      configuration = {
        ClusterName = "app-cluster"
        ServiceName = "app-service"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

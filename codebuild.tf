# Criando do projeto do CodeBuild
resource "aws_codebuild_project" "project" {
  name         = "meu-projeto-codebuild"
  description  = "Projeto do CodeBuild para o meu aplicativo"
  service_role = aws_iam_role.codebuild_role.arn
# NAO VAI SUBIR NADA NO S3
  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/23Ant/terraform-codebuild.git"
    git_clone_depth = 1
  }
}

# Criando role do IAM para o CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

# Anexando política do IAM à role do CodeBuild
resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
  role       = aws_iam_role.codebuild_role.name
}

# Criando bucket do S3 para armazenar os artefatos
resource "aws_s3_bucket" "artifacts" {
  bucket = "meu-bucket-de-artefatos"
}

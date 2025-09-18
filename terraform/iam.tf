# ECS task execution role
data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service"; identifiers = ["ecs-tasks.amazonaws.com"] }
  }
}
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.app_name}-ecs-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}
resource "aws_iam_role_policy_attachment" "ecs_task_exec_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CodeBuild role (inline policy: ECR push, logs, s3)
data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service"; identifiers = ["codebuild.amazonaws.com"] }
  }
}
resource "aws_iam_role" "codebuild_role" {
  name               = "${var.app_name}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json
}
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.app_name}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = [
          "ecr:GetAuthorizationToken", "ecr:InitiateLayerUpload", "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload", "ecr:PutImage", "ecr:BatchCheckLayerAvailability",
          "ecr:DescribeRepositories", "ecr:CreateRepository"
        ], Resource = "*" },
      { Effect = "Allow", Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"], Resource = "*" },
      { Effect = "Allow", Action = ["s3:*"], Resource = "*" },
      { Effect = "Allow", Action = ["sts:AssumeRole"], Resource = "*" }
    ]
  })
}

# CodePipeline role (attach managed policies for simplicity)
data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service"; identifiers = ["codepipeline.amazonaws.com"] }
  }
}
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.app_name}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json
}
resource "aws_iam_role_policy_attachment" "cp_attach_1" {
  role = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}
resource "aws_iam_role_policy_attachment" "cp_attach_2" {
  role = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "cp_attach_3" {
  role = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}
resource "aws_iam_role_policy_attachment" "cp_attach_4" {
  role = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
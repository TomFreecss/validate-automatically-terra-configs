output "ecr_repo_url" { value = aws_ecr_repository.app.repository_url }
output "alb_dns" { value = aws_lb.alb.dns_name }
output "pipeline_name" { value = aws_codepipeline.pipeline.name }

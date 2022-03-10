variable "codebuild_pipeline_name" {
    type = string
    description = "Codebuild pipeline name"
}

variable "codebuild_source_location" {
    type = string
    description = "URI for the source repo the codebuild pipeline uses"
}

variable "codebuild_github_source_branch" {
    type = string
    description = "Branch name"
}

variable "codebuild_source_type" {
    type = string
    description = "Codebuild source type (e.g. GITHUB)"
}

variable "codebuild_source_buildspec" {
    type = string
    description = "Codebuild Buildspec"
}

variable "codebuild_compute_type" {
    type = string
    description = "Codebuild Compute Type"
    default = "BUILD_GENERAL1_SMALL"
}

variable "codebuild_image" {
    type = string
    description = "Codebuild Image"
    default = "aws/codebuild/standard:5.0"
}

variable "codebuild_container_type" {
    type = string
    description = "Codebuild Container Type"
    default = "LINUX_CONTAINER"
}

variable "codebuild_image_pull_credentials_type" {
    type = string
    description = "Codebuild Image Pull Credentials Type"
    default = "CODEBUILD"
}

variable "codebuild_subnet_ids" {
  type = list(any)
}

variable "codebuild_vpc_id" {
  type = string
}

variable "codebuild_security_group_id" {
  type = list(any)
}

variable "github-ro-token" {
  type = string
}

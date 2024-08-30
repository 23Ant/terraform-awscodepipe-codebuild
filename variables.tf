variable "github_token" {
  description = "colocaraporradogithubsecretsnesseslocais"
  type        = string
  sensitive   = true
}

variable "repo_name" {
  description = "terraform-awscodepipe-codebuild"
  type        = string
  default     = "terraform-codebuild"
}

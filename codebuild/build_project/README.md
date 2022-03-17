# build-and-deploy-terraform-modules

### Build Project

Terraform module which implements a Codebuild Build Project with the inputs provided by the terraform calling it.

## Usage

* This example uses this module to create a build project that pulls a repository from Github, installs Terraform and runs the Terraform code contained in the repo.

```hcl
module "my-favourite-build-project" {
  source                         = "github.com/hmrc/build-and-deploy-terraform-modules.git//codebuild/build_project"
  github-ro-token                = "github-example-token"
  codebuild_build_project_name        = "my-build-project-name"
  codebuild_source_location      = "https://github.com/myexamplerepo.git"
  codebuild_source_type          = "GITHUB"
  codebuild_github_source_branch = "mybranch"
  codebuild_vpc_id               = var.workspace_variables[local.environment]["my_vpc_id"]
  codebuild_security_group_id    = var.workspace_variables[local.environment]["my_security_group_id"]
  codebuild_subnet_ids           = var.workspace_variables[local.environment]["my_private_subnet_ids"]
  codebuild_source_buildspec = yamlencode({
    version = 0.2

    env = {
      parameter-store = {
        TF_VAR_bearer_token = "/accesstoken/bearer_token"
      }
      variables = {
        TF_VAR_service_url = var.workspace_variables[local.environment]["service_url"],
        terraform_state_bucket = var.workspace_variables[local.environment]["terraform_state_bucket"]
      }
    }
    phases = {
      install = {
        commands = [
          "curl -Lo terraform_1.1.0_linux_amd64.zip https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip",
          "unzip terraform_1.1.0_linux_amd64.zip",
          "mv terraform /usr/local/bin/"
        ]
      }
      build = {
        commands = [
          "terraform init -backend-config=\"bucket=${var.workspace_variables[local.environment]["terraform_state_bucket"]}\"",
          "terraform apply -auto-approve"
        ]
      }
    }
  })
}
```

### Prerequisites

In order to successfully use this module, you require the following:

* An AWS account in which to run the codebuild project.

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/hmrc/build-and-deploy-terraform-modules/issues) section.

PRs are welcomed. More specific guidance will be added in future.

## Requirements

No requirements

## Providers

No providers

## Modules

No modules.

## Resources

|Name|Type|Description|
|-|-|-|
|aws_codebuild_project.codebuild_build_project|resource|Codebuild Project|
|aws_codebuild_source_credential.codebuild_github_credential|resource|Github credential|

## Inputs

|Name|Description|Type|Default|Required|
|-|-|-|-|-|
|codebuild_build_project_name|Name of the Codebuild Project|`string`|n/a|yes|
|codebuild_source_location|Source code location of codebuild definition (e.g. github uri)|`string`|n/a|yes|
|codebuild_github_source_branch|Github branch of the source to use (for development mainly. Will default to 'main'|`string`|n/a|yes|
|codebuild_source_type|Source type (e.g. GITHUB)|`string`|n/a|yes|
|codebuild_source_buildspec|Definition of the build spec|`string`|n/a|yes|
|codebuild_compute_type|AWS Compute Type|`string`|`BUILD_GENERAL1_SMALL`|yes|
|codebuild_image|Codebuild Image used|`string`|`aws/codebuild/standard:5.0`|yes|
|codebuild_container_type|Codebuild container type|`string`|`LINUX_CONTAINER`|yes|
|codebuild_image_pull_credentials_type|Cedentials type used for pulling image|`string`|`CODEBUILD`|yes|
|codebuild_subnet_ids|Subnets in which the Codebuild Project will operate|`list(any)`|n/a|yes|
|codebuild_vpc_id|VPC in which the Codebuild Project will operate|`string`|n/a|yes|
|codebuild_security_group_id|SG used by the Codebuild Project|`string`|n/a|yes|
|github-ro-token|Read only token for pulling from Github|`string`|n/a|yes|

## Outputs

|Name|Value|Description|
|-|-|-|
|codebuild_execution_role_id|aws_iam_role.codebuild_execution_role.id|ID of IAM role used during execution of build project|

## License

This code is open source software licensed under the [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html").

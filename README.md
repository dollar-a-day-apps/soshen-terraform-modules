# soshen-terraform-modules

To avoid needing a GitHub repository for every single module, we're going to have to use Terraform's git revision selecting functionality.


Basically, each branch will have be its own module and we will reference this in the module `source` input by appending `?ref=BRANCH_NAME` to the GitHub repo URL.


For more details, see here: https://www.terraform.io/docs/modules/sources.html#selecting-a-revision.

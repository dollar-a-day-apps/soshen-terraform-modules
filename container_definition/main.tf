# Credit: https://github.com/cloudposse/terraform-aws-ecs-container-definition/blob/master/main.tf
# Our own translation of cloudposse's above module
locals {
  container_definition = {
    name         = var.container_name
    image        = var.container_image
    portMappings = var.port_mappings

    logConfiguration = {
      # Already set to "awslogs" by default - which is what we need for Fargate
      logDriver = var.log_driver
      options   = var.log_options
    }

    # cpu                    = var.container_cpu
    # memory                 = var.container_memory
    # memoryReservation      = var.container_memory_reservation
    # essential              = var.essential
    # entryPoint             = var.entrypoint
    # command                = var.command
    # workingDirectory       = var.working_directory
    # readonlyRootFilesystem = var.readonly_root_filesystem
    # mountPoints            = var.mount_points
    # dnsServers             = var.dns_servers
    # ulimits                = var.ulimits
    # repositoryCredentials  = var.repository_credentials
    # links                  = var.links
    # volumesFrom            = var.volumes_from
    # healthCheck            = var.healthcheck

    # These values are encoded prior to the module outputting the container definition JSON
    environment = "environment_sentinel_value"
    secrets     = "secrets_sentinel_value"
  }

  environment = var.environment
  secrets     = var.secrets
}

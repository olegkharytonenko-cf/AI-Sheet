module "mgmt_vpc" {
  source = "../modules/vpc"
  providers = {
    aws = aws.ai-sheet
  }

  name = "AI-sheet"

  delete_protection = true

  cidr = "${var.ip_network_mgmt}.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b"]

  private_subnets = [
    "${var.ip_network_mgmt}.2.0/24",#ai-sheet
    "${var.ip_network_mgmt}.3.0/24",#ai-sheet

  ]
  
  private_subnet_tags = {
    "0"  = "AI"
    "1"  = "AI"
  }

  private_az = {
    "0"  = "${data.aws_region.current.name}a"
    "1"  = "${data.aws_region.current.name}b"
  }

  public_subnets = [
    "${var.ip_network_mgmt}.0.0/24",
    "${var.ip_network_mgmt}.1.0/24",
  ]

  public_az = {
    "0" = "${var.aws_region}a"
    "1" = "${var.aws_region}b"
  }

  public_subnet_suffix = "public"

  single_nat_gateway     = false
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true
  #dhcp_options_domain_name = local.domain_name
  #dhcp_options_domain_name_servers = ["${local.ip_network_mgmt}.${local.directory_ip_1}", "${local.ip_network_mgmt}.${local.directory_ip_2}"]

  #flow_log_destination_type              = "cloud-watch-logs"
  #cloudwatch_log_group_retention_in_days = 30
  #cloudwatch_log_group_kms_key_id        = data.terraform_remote_state.setup.outputs.cloudwatch_key_arn
  ### Network Firewall ###
  deploy_aws_nfw                        = true
  aws_nfw_prefix                        = var.resource_prefix
  aws_nfw_name                          = "nfw"
  #aws_nfw_domain_stateful_rule_group    = local.domain_stateful_rule_group_shrd_svcs
  nfw_kms_key_id                        = aws_kms_key.nfw_key.arn

  # When deploying NFW, firewall_subnets must be specified
  firewall_subnets       = [  
    "${var.ip_network_mgmt}.14.0/24", 
    "${var.ip_network_mgmt}.15.0/24", 
    ]
  firewall_subnet_suffix = "firewall"


  /* Add Additional tags here */
  tags = {
    Owner       = var.resource_prefix
    Environment = "mgmt"
    createdBy   = var.createdByTag
  }
}
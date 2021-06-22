################################################################################################

# Create an AWS VPC
resource "aviatrix_vpc" "aws_vpc_hrs" {
  cloud_type           = 1
  account_name         = var.aws_acct
  region               = var.transit1_region
  name                 = var.transit1_vpc_name
  cidr                 = var.transit1_cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = true
}

# Create an Aviatrix AWS Transit Network Gateway
resource "aviatrix_transit_gateway" "transit_gateway_aws_hrs" {
  cloud_type               = 1
  account_name             = var.aws_acct
  gw_name                  = var.transit1_name
  vpc_id                   = aviatrix_vpc.aws_vpc_hrs.vpc_id
  vpc_reg                  = var.transit1_region
  gw_size                  = var.instance_size
  #subnet                   = local.subnet
  #ha_subnet                = var.ha_gw ? local.ha_subnet : null
  subnet                   = aviatrix_vpc.aws_vpc_hrs.public_subnets[0].cidr
  ha_subnet                = aviatrix_vpc.aws_vpc_hrs.public_subnets[2].cidr
  ha_gw_size               = var.instance_size
  enable_active_mesh       = true
  enable_hybrid_connection = false
  connected_transit        = false
  enable_transit_firenet   = true
  enable_egress_transit_firenet    = var.enable_egress_transit_firenet
}

################################################################################################
# Create an AWS VPC 2
resource "aviatrix_vpc" "aws_vpc2_hrs" {
  cloud_type           = 1
  account_name         = var.aws_acct
  region               = var.transit2_region
  name                 = var.transit2_vpc_name
  cidr                 = var.transit2_cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = true
}

# Create an Aviatrix AWS Transit Network Gateway
resource "aviatrix_transit_gateway" "transit2_gateway_aws_hrs" {
  cloud_type               = 1
  account_name             = var.aws_acct
  gw_name                  = var.transit2_name
  vpc_id                   = aviatrix_vpc.aws_vpc2_hrs.vpc_id
  vpc_reg                  = var.transit2_region
  gw_size                  = var.instance_size
  subnet                   = aviatrix_vpc.aws_vpc2_hrs.public_subnets[0].cidr
  ha_subnet                = aviatrix_vpc.aws_vpc2_hrs.public_subnets[2].cidr
  ha_gw_size               = var.instance_size
  enable_active_mesh       = true
  enable_hybrid_connection = false
  connected_transit        = false
  enable_transit_firenet   = true
  enable_egress_transit_firenet    = var.enable_egress_transit2_firenet
}

################################################################################################

# Create an AWS Spoke VPC 1
resource "aviatrix_vpc" "aws_spoke_vpc_hrs" {
  cloud_type           = 1
  account_name         = var.aws_acct
  region               = var.spoke1_region
  name                 = var.spoke1_vpc_name
  cidr                 = var.spoke1_cidr
  aviatrix_transit_vpc = false
  aviatrix_firenet_vpc = false
}

# Create an Aviatrix AWS Spoke Gateway
resource "aviatrix_spoke_gateway" "spoke_gateway_aws_hrs" {
  cloud_type                        = 1
  account_name                      = var.aws_acct
  gw_name                           = var.spoke1_name
  vpc_id                            = aviatrix_vpc.aws_spoke_vpc_hrs.vpc_id
  vpc_reg                           = var.spoke1_region
  gw_size                           = var.spoke1_instance_size
  ha_gw_size                        = var.spoke1_instance_size
  subnet                            = aviatrix_vpc.aws_spoke_vpc_hrs.public_subnets[0].cidr
  ha_subnet                         = aviatrix_vpc.aws_spoke_vpc_hrs.public_subnets[1].cidr
  single_ip_snat                    = false
  enable_active_mesh                = true
  manage_transit_gateway_attachment = false
}

# Create an Aviatrix Spoke Transit Attachment for Egress
resource "aviatrix_spoke_transit_attachment" "attachment1" {
  spoke_gw_name   = aviatrix_spoke_gateway.spoke_gateway_aws_hrs.gw_name
  transit_gw_name = aviatrix_transit_gateway.transit_gateway_aws_hrs.gw_name
  #route_tables    = [
  #  "rtb-737d540c",
  #  "rtb-626d045c"
  #]
}

# Create an Aviatrix Spoke Transit Attachment for Inspection
resource "aviatrix_spoke_transit_attachment" "attachment2" {
  spoke_gw_name   = aviatrix_spoke_gateway.spoke_gateway_aws_hrs.gw_name
  transit_gw_name = aviatrix_transit_gateway.transit2_gateway_aws_hrs.gw_name
  #route_tables    = [
   # "rtb-737d540c",
   # "rtb-626d045c"
  #]
}

################################################################################################


# Create an Aviatrix Firewall Instance
resource "aviatrix_firewall_instance" "hrs_firewall_instance" {
  vpc_id            = aviatrix_vpc.aws_vpc_hrs.vpc_id
  firenet_gw_name   = aviatrix_transit_gateway.transit_gateway_aws_hrs.gw_name
  firewall_name     = var.firewall_name 
  firewall_image    = var.firewall_image
  firewall_size     = var.fw_instance_size
  management_subnet = aviatrix_vpc.aws_vpc_hrs.public_subnets[0].cidr
  egress_subnet     = aviatrix_vpc.aws_vpc_hrs.public_subnets[1].cidr
}

# Associate an Aviatrix FireNet Gateway with a Firewall Instance
resource "aviatrix_firewall_instance_association" "firewall_instance_association_1" {
  vpc_id               = aviatrix_vpc.aws_vpc_hrs.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.transit_gateway_aws_hrs.gw_name
  instance_id          = aviatrix_firewall_instance.hrs_firewall_instance.instance_id
  firewall_name        = aviatrix_firewall_instance.hrs_firewall_instance.firewall_name
  lan_interface        = aviatrix_firewall_instance.hrs_firewall_instance.lan_interface
  management_interface = aviatrix_firewall_instance.hrs_firewall_instance.management_interface
  egress_interface     = aviatrix_firewall_instance.hrs_firewall_instance.egress_interface
  attached             = true
}


################################################################################################


# Associate an Aviatrix FireNet Gateway with a Firewall Instance
resource "aviatrix_firewall_instance_association" "firewall_instance_association_2" {
  vpc_id               = aviatrix_vpc.aws_vpc2_hrs.vpc_id
  firenet_gw_name      = aviatrix_transit_gateway.transit2_gateway_aws_hrs.gw_name
  instance_id          = var.firewall2_instance_id
  firewall_name        = var.firewall2_name
  lan_interface        = var.firewall2_lan_interface
  management_interface = var.firewall2_management_interface
  egress_interface     = var.firewall2_egress_interface
  attached             = true
}

################################################################################################

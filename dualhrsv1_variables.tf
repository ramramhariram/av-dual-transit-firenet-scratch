####Some default values: 

variable "instance_size" {
  description = "AWS Instance size for the Aviatrix gateways"
  type        = string
  default     = "c5.xlarge"
}

variable "fw_instance_size" {
  description = "AWS Instance size for the NGFW's"
  type        = string
  default     = "c5.xlarge"
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
}

variable enable_egress_transit_firenet {
  description = "Boolean to determine if egress in firenet should be enabled"
  type        = bool
  default     = false

}

variable enable_egress_transit2_firenet {
  description = "Boolean to determine if egress in firenet should be enabled"
  type        = bool
  default     = false

}

variable insane_mode  {  
  description = "Boolean for insane mode"
  type        = bool
  default     = false
}

variable az1 {   
  description = "az1"
  type        = string
  default     = "a"
}

variable az2 {
  description = "az2"
  type        = string
  default     = "b"
}
 
####PROVIDER and BASIC

variable controller_ip {}           
variable username {}          
variable password {}
variable aws_acct {}      

####RESOURCE SPECIFIC

variable transit1_vpc_name {}
variable transit1_region {}
variable transit1_name {}
variable transit1_cidr {}

variable transit2_vpc_name {}
variable transit2_region {}
variable transit2_name {}
variable transit2_cidr {}

variable spoke1_instance_size {}
variable spoke1_name {}
variable spoke1_cidr {}
variable spoke1_region {}
variable spoke1_vpc_name {}

variable firewall_name  {}  
variable firewall_image {}

variable firewall2_name  {} 
variable firewall2_instance_id {}
variable firewall2_lan_interface {}
variable firewall2_management_interface {}
variable firewall2_egress_interface {}

######LOCALS#####

locals {
 # lower_name              = length(var.name) > 0 ? replace(lower(var.name), " ", "-") : replace(lower(var.region), " ", "-")
 # prefix                  = var.prefix ? "avx-" : ""
 # suffix                  = var.suffix ? "-firenet" : ""
 # is_palo                 = length(regexall("palo", lower(var.firewall_image))) > 0     #Check if fw image is palo. Needs special handling for management_subnet (CP & Fortigate null)
 # is_aviatrix             = length(regexall("aviatrix", lower(var.firewall_image))) > 0 #Check if fw image is Aviatrix FQDN Egress
 # name                    = "${local.prefix}${local.lower_name}${local.suffix}"
  #cidrbits                = tonumber(split("/", var.transit1_cidr)[1])
 # newbits                 = 26 - local.cidrbits
 # netnum                  = pow(2, local.newbits)
 # subnet                  = var.insane_mode ? cidrsubnet(var.transit1_cidr, local.newbits, local.netnum - 2) : aviatrix_vpc.aws_vpc_hrs.public_subnets[0].cidr
 # ha_subnet               = var.insane_mode ? cidrsubnet(var.transit1_cidr, local.newbits, local.netnum - 1) : aviatrix_vpc.aws_vpc_hrs.public_subnets[2].cidr
 # az1                     = "${var.transit1_region}${var.az1}"
 # az2                     = "${var.transit1_region}${var.az2}"
 # insane_mode_az          = var.insane_mode ? local.az1 : null
 # ha_insane_mode_az       = var.insane_mode ? local.az2 : null
 # bootstrap_bucket_name_2 = length(var.bootstrap_bucket_name_2) > 0 ? var.bootstrap_bucket_name_2 : var.bootstrap_bucket_name_1 #If bucket 2 name is not provided, fallback to bucket 1.
 # iam_role_2              = length(var.iam_role_2) > 0 ? var.iam_role_2 : var.iam_role_1                                        #If IAM role 2 name is not provided, fallback to IAM role 1.
}


######Options#####

  #variable fw_API_uname {}
  #variable fw_API_pwd {}
  #variable fw_public_ip {}
  #variable vendor_type {}
  #variable instance_size {} 
  #variable spoke2_name {}
  #variable spoke2_cidr {}
  #variable spoke2_region {}
  #variable vpc_id {}
  #variable transit_gateway_1 {}
  #variable spoke1_ha {}
  #variable spoke2_ha {}
  #variable spoke2_instance_size {}
  # variable attached {}
  # variable active_mesh {}
  # variable security_domain {}
  #variable transit1_instance_size  {}
  #variable transit1_ha {}
  #variable transit2_instance_size  {}
  #variable transit2_ha {}
  # variable connected_transit {}
  # variable learned_cidr_approval {}
  # variable active_mesh {}
  # variable enable_segmentation {}


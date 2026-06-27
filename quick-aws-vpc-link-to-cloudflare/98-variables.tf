#---------------------------------------------------------------------------------------------------
# Variables
#---------------------------------------------------------------------------------------------------
variable "cloudflare_account_id" {
  description = "Cloudflare Account ID — see README Prerequisites section for how to set this value"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Short name used in resource names. Lowercase letters and numbers only."
  type        = string
  default     = "staticsite"

  validation {
    condition     = can(regex("^[a-z0-9]{3,12}$", var.project_name))
    error_message = "project_name must be 3-12 lowercase letters or numbers."
  }
}

variable "location" {
  description = "Azure region to deploy into."
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default = {
    project    = "terraform-azure-static-site"
    managed_by = "terraform"
  }
}

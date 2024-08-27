## Provider-specific modules variables
## Copy to toplevel

## This is meant only to follow the same patter as other cluster types.
variable "modules_defaults" {
  description = "Default (empty) modules to install (default)"
  type = object({
  })
  default = {}
}

locals {
  register_modules = {}
}

variable "target_resource" {
  type        = string
  description = "Apply the policy to this resource. Use 'organizations/ID', 'folders/ID', or 'projects/ID'."
}

variable "policies" {
  type = map(object({
    # Which side of the list are we setting?
    # "allow" -> set allowed_values; "deny" -> set denied_values
    mode          = string                        # "allow" | "deny"
    values        = list(string)                  # the values for the constraint
    enforce       = bool                          # true = unconditional, false = tag-conditional
    tag_key       = optional(string)              # required when enforce = false
    tag_value     = optional(list(string))              # required when enforce = false
    else_behavior = optional(string, "allow_all") # "allow_all" | "deny_all" | "inherit"
  }))

  # Validations
  validation {
    condition     = alltrue([for p in var.policies : contains(["allow", "deny"], lower(p.mode))])
    error_message = "mode must be 'allow' or 'deny'."
  }

  validation {
    condition     = alltrue([for p in var.policies : length(p.values) > 0])
    error_message = "values must contain at least one entry."
  }

  validation {
    condition = alltrue([
      for p in var.policies :
      p.enforce || (try(length(p.tag_key) > 0, false) && try(length(p.tag_value) > 0, false))
    ])
    error_message = "When enforce = false, tag_key and tag_value are required."
  }

  validation {
    condition     = alltrue([for p in var.policies : contains(["allow_all", "deny_all", "inherit"], try(lower(p.else_behavior), "allow_all"))])
    error_message = "else_behavior must be 'allow_all', 'deny_all', or 'inherit' (default 'allow_all')."
  }
}

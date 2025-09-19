variable "target_resource" {
  type        = string
  description = "The resource to apply the policy to. Must be an organization, folder, or project resource name (e.g., 'organizations/1234567890', 'folders/1234567890')."
}
variable "policies" {
  type = map(object({
    enforce     = bool
    policy_type = string # "deny" or "allow"
    tag_key     = string
    tag_value   = string
  }))

  description = "Map of constraint names to policy settings."
}
variable "enforce" {
  type        = bool
  default     = false
  description = <<-EOT
    Whether to enforce the policy unconditionally.

    - If true: applies the constraint to all resources (ignores tag conditions)
    - If false: uses tag-based conditional rules instead
  EOT
}

variable "policy_type" {
  type        = string
  default     = "deny"
  description = <<-EOT
    The type of policy to apply.
    
    - "deny" → enforce = true (or deny via tag condition)
    - "allow" → enforce = false (or allow via tag condition)

    Only used when `enforce = false` to determine condition logic.
  EOT

  validation {
    condition     = contains(["deny", "allow"], var.policy_type)
    error_message = "The policy_type must be either deny or allow."
  }
}

variable "tag_key" {
  type        = string
  description = "The full resource name of the tag key (e.g., 'tagKeys/abc123def456'). Required only when enforce = false."
  default     = null
}

variable "tag_value" {
  type        = string
  description = "The full resource name of the tag value (e.g., 'tagValues/xyz789uvw321'). Required only when enforce = false."
  default     = null
}
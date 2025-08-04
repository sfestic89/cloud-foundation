resource "google_org_policy_policy" "tag_condition_policy" {
  for_each = var.policies

  name   = "${var.target_resource}/policies/${each.key}"
  parent = var.target_resource

  spec {
    inherit_from_parent = false

    # This rule is for unconditional enforcement (when var.enforce is true).
    dynamic "rules" {
      for_each = var.enforce ? [1] : []

      content {
        # For a boolean constraint, setting enforce = true will enforce the policy.
        # "deny" → enforce = TRUE → turn on enforcement
        # "allow" → enforce = FALSE → turn off enforcement
        enforce = var.policy_type == "deny" ? "TRUE" : "FALSE"
      }
    }
    # This rule is for conditional enforcement based on tags (when var.enforce is false).
    dynamic "rules" {
      for_each = !var.enforce ? [1] : []

      content {
        condition {
          expression  = "resource.matchTagId('tagKeys/${each.value.tag_key}', 'tagValues/${each.value.tag_value}')"
          title       = "Tag condition"
          description = "Applies only to resources with this tag"
        }
        enforce = var.policy_type == "deny" ? "TRUE" : "FALSE"
      }
    }

    # This is a default rule for when var.enforce is false. It applies to resources that do NOT match the tag.
    # It applies the opposite behavior of the conditional rule.
    dynamic "rules" {
      for_each = !var.enforce ? [1] : []
      content {
        enforce = var.policy_type == "deny" ? "FALSE" : "TRUE"
      }
    }
  }
}
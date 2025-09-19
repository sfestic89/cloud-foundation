resource "google_org_policy_policy" "tag_condition_policy" {
  for_each = var.policies # constraints/gcp.resourceLocations

  parent = var.target_resource # organizations/123
  name   = "${var.target_resource}/policies/${each.key}"
  #name = "${var.target_resource}/policies/${trimspace(replace(each.key, "constraints/", ""))}"

  spec {
    inherit_from_parent = false # You do not inherit any parent policy;

    # This rule is for unconditional enforcement (when var.enforce is true).
    dynamic "rules" {
      for_each = each.value.enforce ? [1] : []

      content {
        # For a boolean constraint, setting enforce = true will enforce the policy.
        # "deny" → enforce = TRUE → turn on enforcement
        # "allow" → enforce = FALSE → turn off enforcement
        enforce = each.value.policy_type == "deny" ? true : false
      }
    }
    # This rule is for conditional enforcement based on tags (when var.enforce is false).
    dynamic "rules" {
      for_each = !each.value.enforce ? [1] : []

      content {
        condition {
          expression  = "resource.matchTag('${each.value.tag_key}', '${each.value.tag_value}')"
          title       = "Tag condition"
          description = "Applies only to resources with this tag"
        }
        enforce = each.value.policy_type == "deny" ? true : false
      }
    }

    # Default opposite when the tag does NOT match
    dynamic "rules" {
      for_each = !each.value.enforce ? [1] : []
      content {
        enforce = each.value.policy_type == "deny" ? false : true
      }
    }
  }
}
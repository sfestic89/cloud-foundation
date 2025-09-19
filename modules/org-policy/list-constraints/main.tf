resource "google_org_policy_policy" "list_constraint_policy" {
  for_each = var.policies

  parent = var.target_resource                           # e.g. organizations/1234567890
  name   = "${var.target_resource}/policies/${each.key}" # e.g. organizations/.../policies/gcp.resourceLocations

  spec {
    inherit_from_parent = false

    # 1) Unconditional list (apply everywhere)
    dynamic "rules" {
      for_each = each.value.enforce ? [1] : []
      content {
        values {
          allowed_values = each.value.mode == "allow" ? each.value.values : null
          denied_values  = each.value.mode == "deny" ? each.value.values : null
        }
      }
    }

    # 2) Tag-conditional list (apply ONLY when tag matches)
    dynamic "rules" {
      for_each = !each.value.enforce ? [1] : []
      content {
        condition {
          expression  = "resource.matchTag('${each.value.tag_key}', '${each.value.tag_value}')"
          title       = "Tag condition"
          description = "Applies only to resources with this tag"
        }
        values {
          allowed_values = each.value.mode == "allow" ? each.value.values : null
          denied_values  = each.value.mode == "deny" ? each.value.values : null
        }
      }
    }

    # 3) Default for NOT tagged resources (opposite branch): allow all by default
    dynamic "rules" {
      for_each = (!each.value.enforce && try(each.value.else_behavior, "allow_all") != "inherit") ? [1] : []
      content {
        values {
          # Choose the fallback behavior for non-matching resources.
          allowed_values = try(each.value.else_behavior, "allow_all") == "allow_all" ? true : null
          denied_values  = try(each.value.else_behavior, "allow_all") == "deny_all" ? true : null
          
        }
      }
    }
  }
}
# Copyright © 2024 Joseph Wright <joseph@cloudboss.co>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

locals {
  security_group_rules_keys = [for rule in var.rules : [
    rule.cidr_ipv4 == null ? "" : rule.cidr_ipv4,
    rule.cidr_ipv6 == null ? "" : rule.cidr_ipv6,
    rule.description == null ? "" : rule.description,
    rule.from_port == null ? "" : rule.from_port,
    rule.ip_protocol == null ? "" : (rule.ip_protocol == "-1" ? "all" : rule.ip_protocol),
    rule.prefix_list_id == null ? "" : rule.prefix_list_id,
    rule.referenced_security_group == null ? "" : rule.referenced_security_group,
    rule.to_port == null ? "" : rule.to_port,
  ]]

  security_group_rules_egress = { for i, rule in var.rules :
    join("-", [for k in local.security_group_rules_keys[i] : k if k != ""]) => {
      cidr_ipv4                 = rule.cidr_ipv4
      cidr_ipv6                 = rule.cidr_ipv6
      description               = rule.description
      from_port                 = rule.from_port
      ip_protocol               = rule.ip_protocol
      prefix_list_id            = rule.prefix_list_id
      referenced_security_group = rule.referenced_security_group
      tags                      = merge(var.tags, rule.tags)
      to_port                   = rule.to_port
  } if rule.type == "egress" }

  security_group_rules_ingress = { for i, rule in var.rules :
    join("-", [for k in local.security_group_rules_keys[i] : k if k != ""]) => {
      cidr_ipv4                 = rule.cidr_ipv4
      cidr_ipv6                 = rule.cidr_ipv6
      description               = rule.description
      from_port                 = rule.from_port
      ip_protocol               = rule.ip_protocol
      prefix_list_id            = rule.prefix_list_id
      referenced_security_group = rule.referenced_security_group
      tags                      = merge(var.tags, rule.tags)
      to_port                   = rule.to_port
  } if rule.type == "ingress" }
}

resource "aws_vpc_security_group_egress_rule" "them" {
  for_each = local.security_group_rules_egress

  cidr_ipv4      = each.value.cidr_ipv4
  cidr_ipv6      = each.value.cidr_ipv6
  description    = each.value.description
  from_port      = each.value.from_port
  ip_protocol    = each.value.ip_protocol
  prefix_list_id = each.value.prefix_list_id
  referenced_security_group_id = (
    each.value.referenced_security_group == null
    ? null
    : var.mapping[each.value.referenced_security_group]
  )
  security_group_id = var.security_group_id
  tags              = length(each.value.tags) > 0 ? each.value.tags : null
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_ingress_rule" "them" {
  for_each = local.security_group_rules_ingress

  cidr_ipv4      = each.value.cidr_ipv4
  cidr_ipv6      = each.value.cidr_ipv6
  description    = each.value.description
  from_port      = each.value.from_port
  ip_protocol    = each.value.ip_protocol
  prefix_list_id = each.value.prefix_list_id
  referenced_security_group_id = (
    each.value.referenced_security_group == null
    ? null
    : var.mapping[each.value.referenced_security_group]
  )
  security_group_id = var.security_group_id
  tags              = length(each.value.tags) > 0 ? each.value.tags : null
  to_port           = each.value.to_port
}

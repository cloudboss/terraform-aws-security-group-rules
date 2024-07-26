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

variable "mapping" {
  type        = map(string)
  description = "A mapping of names to security group IDs. The names are used in the rules to reference the security groups, rather than the IDs, as Terraform may fail when the IDs come from resources that are not yet created (this is a workaround for limitations of for_each)."

  default = {}
}

variable "rules" {
  type = list(object({
    cidr_ipv4                 = optional(string, null)
    cidr_ipv6                 = optional(string, null)
    description               = optional(string, null)
    from_port                 = optional(number, null)
    ip_protocol               = string
    prefix_list_id            = optional(string, null)
    referenced_security_group = optional(string, null)
    tags                      = optional(map(string), null)
    to_port                   = optional(number, null)
    type                      = string
  }))
  description = "A list of rules to create in the security group."

  default = []
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group."
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the security group rules."

  default = {}
}

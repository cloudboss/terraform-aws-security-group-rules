# security-group-rules

A module to configure security group rules.

## Example

```
locals {
  security_group_mapping = {
    "application" = "sg-828a7ef11b6a44ac9"
    "db"          = "sg-00eead5529e26385b"
    "lb"          = "sg-09837cf1256ae9aab"
  }
  ports = {
    application = 8080
	db          = 5432
    https       = 443
  }
  vpc_cidr = "172.30.0.0/16"
}

module "security_group_rules_db" {
  source  = "cloudboss/security-group-rules/aws"
  version = "x.x.x"

  mapping = local.security_group_mapping
  rules = [
    {
      from_port                 = local.ports.db
      ip_protocol               = "tcp"
      referenced_security_group = "application"
      to_port                   = local.ports.db
      type                      = "ingress"
    },
  }
  security_group_id = local.mapping.db
}

module "security_group_rules_lb" {
  source  = "cloudboss/security-group-rules/aws"
  version = "x.x.x"

  mapping = local.security_group_mapping
  rules = [
    {
      from_port                 = local.ports.application
      ip_protocol               = "tcp"
      referenced_security_group = "application"
      to_port                   = local.ports.application
      type                      = "egress"
    },
    {
      cidr_ipv4   = local.vpc_cidr
      from_port   = local.ports.https
      ip_protocol = "tcp"
      to_port     = local.ports.https
      type        = "ingress"
    },
  ]
  security_group_id = local.mapping.lb
}

module "security_group_rules_application" {
  source  = "cloudboss/security-group-rules/aws"
  version = "x.x.x"

  mapping = local.security_group_mapping
  rules = [
    {
      from_port                 = local.ports.db
      ip_protocol               = "tcp"
      referenced_security_group = "db"
      to_port                   = local.ports.db
      type                      = "egress"
    },
    {
      from_port                 = local.ports.application
      ip_protocol               = "tcp"
      referenced_security_group = "lb"
      to_port                   = local.ports.application
      type                      = "ingress"
    },
  }
  security_group_id = local.mapping.application
}
```

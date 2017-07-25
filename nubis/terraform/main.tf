module "worker" {
  source            = "github.com/nubisproject/nubis-terraform//worker?ref=v1.5.0"
  region            = "${var.region}"
  environment       = "${var.environment}"
  account           = "${var.account}"
  service_name      = "${var.service_name}"
  ami               = "${var.ami}"
  elb               = "${module.load_balancer.name}"
  instance_type     = "${var.instance_type}"
  nubis_sudo_groups = "team_webops,nubis_global_admins"
}

module "load_balancer" {
  source       = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v1.5.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"

  health_check_target = "HTTP:80/"
}

module "dns" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v1.5.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer.address}"
}

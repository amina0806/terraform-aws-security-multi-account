
module "config" {
  source      = "../../modules/config"

  name_prefix = local.name_prefix

  conformance_pack_name   = "starter-dev"
  enable_conformance_pack = true

  # conformance_pack_template_file = "${path.module}/conformance/step3-custom.yaml"

  tags = merge(local.tags, { Step = "3-config" })
}

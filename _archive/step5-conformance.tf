resource "aws_config_conformance_pack" "step5_custom" {
  name          = "step5_custom"
  template_body = file("${path.module}/conformance/step5-custom.yaml")

  input_parameter {
    parameter_name  = "AllowedKmsKeyArns"
    parameter_value = "arn:aws:kms:us-east-1:958006149724:key/mrk-27d3409cf7c04b4ea998f16c7ae654a0"
  }
}

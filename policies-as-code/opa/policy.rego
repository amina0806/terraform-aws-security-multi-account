package terraform.security


exists_securityhub if {
  some i
  rc := input.resource_changes[i]
  rc.type == "aws_securityhub_account"
  rc.change.after != null
}


deny contains msg if {
  not exists_securityhub
  msg := "Security Hub is not enabled in plan."
}

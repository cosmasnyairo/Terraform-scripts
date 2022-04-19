variable "tags" {
  type = map(any)
}
variable "response_headers" {
  type = map(any)
}
variable "response_headers2" {
  type = map(any)
}
variable "response_headers3" {
  type = map(any)
}
variable "response_models" {
  type = map(any)
}
variable "response_templates" {
  type = map(any)
}
variable "endpoint_configuration" {
  type = list(any)
}
variable "vpc_link_target_arns" {
  type = list(any)
}
variable "authorizer" {
  type = list(any)
}
variable "identity_source" {
  type = string
}
variable "authorizer_type" {
  type = string
}
variable "authorization_scopes" {
  type = string
}
variable "method1" {
  type = string
}
variable "method2" {
  type = string
}
variable "method2_authorization" {
  type = string
}
variable "api_key_required" {
  type = bool
}
variable "integration_type" {
  type = string
}
variable "integration_type1" {
  type = string
}
variable "integration_connection_type" {
  type = string
}
variable "uri" {
  type = string
}
variable "status_code" {
  type = string
}
variable "response_type" {
  type = string
}
variable "response_type2" {
  type = string
}
variable "quota_settings_offset" {
  type = number
}
variable "quota_settings_limit" {
  type = number
}
variable "quota_settings_period" {
  type = string
}
variable "throttle_settings_burst_limit" {
  type = number
}
variable "throttle_settings_rate_limit" {
  type = number
}

variable "tags" {
  type = map(any)
}
variable "origin_ssl_protocols" {
  type = list(any)
}
variable "allowed_methods" {
  type = list(any)
}
variable "cached_methods" {
  type = list(any)
}
variable "encryption_type" {
  type = string
}
variable "validation_method" {
  type = string
}
variable "cloudfront_description" {
  type = string
}
variable "path_pattern1" {
  type = string
}
variable "origin_domain_name" {
  type = string
}
variable "domain_name" {
  type = string
}
variable "alt_domain" {
  type = string
}
variable "origin_domain_id" {
  type = string
}
variable "viewer_protocol_policy" {
  type = string
}
variable "cache_policy_id" {
  type = string
}
variable "cache_policy_id_1" {
  type = string
}
variable "origin_request_policy_id" {
  type = string
}
variable "origin_request_policy_id_1" {
  type = string
}
variable "protocal_version" {
  type = string
}
variable "origin_protocol_policy" {
  type = string
}
variable "route53_description" {
  type = string
}
variable "ssl_support_method" {
  type = string
}
variable "http_port" {
  type = string
}
variable "https_port" {
  type = string
}

# ECR
resource "aws_ecr_repository" "ecrs" {
  for_each = var.resources
  name = each.key
  encryption_configuration {
    encryption_type = var.encryption_type
  }
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    var.tags,
    {
      Name = each.key
    },
  )
}


# SSL Certificate
resource "aws_acm_certificate" "test_cert" {
  provider = aws.us-east
  private_key      = sensitive(file("test-aws.key"))
  certificate_body = sensitive(file("test.crt"))
  
  tags = merge(
    var.tags,
    {
      Name = "test_cert"
    },
  )
}

# Cloudfront
resource "aws_cloudfront_distribution" "test_distribution" {
 
  origin {
    custom_origin_config {
      http_port = var.http_port
      https_port = var.https_port
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols = var.origin_ssl_protocols
    }
    domain_name = var.origin_domain_name
    origin_id   = var.origin_domain_id
  }
  enabled = true
  comment = var.cloudfront_description

  default_cache_behavior {
    allowed_methods          = var.allowed_methods
    cached_methods           = var.cached_methods
    target_origin_id         = var.origin_domain_id
    viewer_protocol_policy   = var.viewer_protocol_policy
    cache_policy_id          = var.cache_policy_id
    origin_request_policy_id = var.origin_request_policy_id
  }
  ordered_cache_behavior {
    path_pattern             = var.path_pattern1
    allowed_methods          = var.allowed_methods
    cached_methods           = var.cached_methods
    target_origin_id         = var.origin_domain_id
    viewer_protocol_policy   = var.viewer_protocol_policy
    cache_policy_id          = var.cache_policy_id_1
    origin_request_policy_id = var.origin_request_policy_id_1
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn =   aws_acm_certificate.test_cert.arn
    minimum_protocol_version = var.protocal_version
    ssl_support_method = var.ssl_support_method
  }
  is_ipv6_enabled = false
  tags = merge(
    var.tags,
    {
      Name = "test_distribution"
    },
  )
}

#Wait for ec2 instance to pass status checks
resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws cloudfront wait distribution-deployed --id ${aws_cloudfront_distribution.test_distribution.id}"
  }
  depends_on = [
    aws_cloudfront_distribution.test_distribution
  ]
}


#Route 53
resource "aws_route53_zone" "test_route_53" {
  name    = var.domain_name
  comment = var.route53_description
  tags = merge(
    var.tags,
    {
      Name = "test_route_53"
    },
  )
}

resource "aws_route53_record" "test_a_record" {
  zone_id = aws_route53_zone.test_route_53.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name = aws_cloudfront_distribution.test_distribution.domain_name
    zone_id = aws_cloudfront_distribution.test_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
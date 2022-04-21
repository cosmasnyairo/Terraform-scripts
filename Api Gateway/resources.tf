# Create Rest Api
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "Terraform Demo Api"
  description = "Demo Api created using terraform"
  endpoint_configuration {
    types = var.endpoint_configuration
  }
  tags = merge(
    var.tags,
    {
      Name = "Terraform Demo Api"
    },
  )
}

# Create Authorizer
resource "aws_api_gateway_authorizer" "test-authorizer" {
  name            = "test-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.rest_api.id
  type            = var.authorizer_type
  provider_arns   = var.authorizer
  identity_source = var.identity_source
}

# Create Base Resource
resource "aws_api_gateway_resource" "testing_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "Testing"
}

# Create Resource
resource "aws_api_gateway_resource" "rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_resource.testing_api_resource.id
  path_part   = "v1"
}


#Create Method & Method Request
resource "aws_api_gateway_method" "test-method" {
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  resource_id          = aws_api_gateway_resource.rest_api_resource.id
  http_method          = var.method1
  authorization        = var.authorizer_type
  authorizer_id        = aws_api_gateway_authorizer.test-authorizer.id
  authorization_scopes = [var.authorization_scopes]
  api_key_required     = var.api_key_required

}

#Create Options Method & Method Request
resource "aws_api_gateway_method" "test-method1" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_api_resource.id
  http_method   = var.method2
  authorization = var.method2_authorization
}

#create Integration Request
resource "aws_api_gateway_integration" "test-integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_api_resource.id
  http_method             = aws_api_gateway_method.test-method.http_method
  type                    = var.integration_type
  connection_type         = var.integration_connection_type
  connection_id           = replace("+{stageVariables.vpcid}" , "+", "$")
  integration_http_method = aws_api_gateway_method.test-method.http_method
  uri                     = replace("${var.uri_start}/+{stageVariables.url}/${var.uri_end}" , "+", "$")
}

#create Options Integration Request
resource "aws_api_gateway_integration" "test-integration1" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.rest_api_resource.id
  http_method = aws_api_gateway_method.test-method1.http_method
  type        = var.integration_type1
}

# create Method Response
resource "aws_api_gateway_method_response" "test-method-response" {
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  resource_id         = aws_api_gateway_resource.rest_api_resource.id
  http_method         = aws_api_gateway_method.test-method.http_method
  status_code         = var.status_code
  response_parameters = var.response_headers2
  response_models     = var.response_models
}

# create Options Method Response
resource "aws_api_gateway_method_response" "test-method-response1" {
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  resource_id         = aws_api_gateway_resource.rest_api_resource.id
  http_method         = aws_api_gateway_method.test-method1.http_method
  status_code         = var.status_code
  response_parameters = var.response_headers2
  response_models     = var.response_models
}

# create Integration Response
resource "aws_api_gateway_integration_response" "test-integration-response" {
  rest_api_id        = aws_api_gateway_rest_api.rest_api.id
  resource_id        = aws_api_gateway_resource.rest_api_resource.id
  http_method        = aws_api_gateway_method.test-method.http_method
  status_code        = aws_api_gateway_method_response.test-method-response.status_code
  response_templates = var.response_templates
  depends_on = [
    aws_api_gateway_integration.test-integration
  ]
}

# create Options Integration Response
resource "aws_api_gateway_integration_response" "test-integration-response1" {
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  resource_id         = aws_api_gateway_resource.rest_api_resource.id
  http_method         = aws_api_gateway_method.test-method1.http_method
  status_code         = aws_api_gateway_method_response.test-method-response1.status_code
  response_templates  = var.response_templates
  response_parameters = var.response_headers3
  depends_on = [
    aws_api_gateway_integration.test-integration1
  ]
}

# Update 4XX Gateway Response headers
resource "aws_api_gateway_gateway_response" "test_gateway_reponse" {
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  response_type       = var.response_type
  response_parameters = var.response_headers
}

# Update 5XX Gateway Response headers
resource "aws_api_gateway_gateway_response" "test_gateway_reponse1" {
  rest_api_id         = aws_api_gateway_rest_api.rest_api.id
  response_type       = var.response_type2
  response_parameters = var.response_headers
}

# Create Deployment
resource "aws_api_gateway_deployment" "test-deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.test-method,
    aws_api_gateway_method.test-method1,
    aws_api_gateway_gateway_response.test_gateway_reponse,
    aws_api_gateway_gateway_response.test_gateway_reponse1,
    aws_api_gateway_integration_response.test-integration-response,
    aws_api_gateway_integration_response.test-integration-response1
  ]
}

# Create Stage
resource "aws_api_gateway_stage" "uat" {
  deployment_id = aws_api_gateway_deployment.test-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "uat"
  variables = {
    "vpcid" = var.vpclinkid,
    "uri" = var.base_uri
  }
  tags = merge(
    var.tags,
    {
      Name = "Terraform Demo Api"
    },
  )
}

# Add Api Key
resource "aws_api_gateway_api_key" "test-api-key" {
  name        = "test-api-key"
  description = "Test API Key"
  tags = merge(
    var.tags,
    {
      Name = "Terraform Demo Api"
    },
  )
}

# Add Usage Plan
resource "aws_api_gateway_usage_plan" "test-usage-plan" {
  name        = "test-usage-plan"
  description = "Test Usage Plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api.id
    stage  = aws_api_gateway_stage.uat.stage_name
  }
  quota_settings {
    limit  = var.quota_settings_limit
    offset = var.quota_settings_offset
    period = var.quota_settings_period
  }
  throttle_settings {
    burst_limit = var.throttle_settings_burst_limit
    rate_limit  = var.throttle_settings_rate_limit
  }
  tags = merge(
    var.tags,
    {
      Name = "Terraform Demo Api"
    },
  )
}

# Add Usage Plan Key
resource "aws_api_gateway_usage_plan_key" "test-usage-plan-key" {
  key_id        = aws_api_gateway_api_key.test-api-key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.test-usage-plan.id
}

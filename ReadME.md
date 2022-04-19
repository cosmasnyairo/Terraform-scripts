# Documenting terraform scripts to create resources

Since we're using an external backend config:

Replace the key, bucket and region to your use case i.e

- key = name of tfstate file to be stored in s3
- bucket = bucket to store your tfstate files
- region = aws region to use for the backend

```hcl
 terraform init \
    -backend-config="../backend.hcl" \
    -backend-config="key=test.tfstate" \ 
    -backend-config="bucket=test-bucket" \
    -backend-config="region=eu-west-1"
```

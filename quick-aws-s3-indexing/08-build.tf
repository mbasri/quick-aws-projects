#---------------------------------------------------------------------------------------------------
# Build Go
#---------------------------------------------------------------------------------------------------
resource "null_resource" "build" {
  triggers = {
    main_go    = filesha256("${path.module}/src/main.go")
    go_mod     = filesha256("${path.module}/src/go.mod")
    go_sum     = filesha256("${path.module}/src/go.sum")
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      cd ${path.module}/src
      GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go mod download
      GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o ../outputs.d/bootstrap main.go
    EOT
  }
}


#---------------------------------------------------------------------------------------------------
# Create Zip
#---------------------------------------------------------------------------------------------------
data "archive_file" "lambda" {
  type  = "zip"

  source_file = "${path.module}/outputs.d/bootstrap"
  output_path = "${path.module}/outputs.d/lambda.zip"

  depends_on = [
    null_resource.build
  ]
}


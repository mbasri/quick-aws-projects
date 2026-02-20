package main

import (
	"fmt"
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/lambda"
	// "github.com/aws/aws-sdk-go-v2/config"
	// "github.com/aws/aws-sdk-go-v2/service/s3"
)

func init() {
	fmt.Println("Initializing Go Lambda...")
}

func handler(ctx context.Context, event json.RawMessage) () {
    fmt.Println("Handler invoked!")
    fmt.Printf("Event: %+v\n", event)
}

func main() {
	  fmt.Println("Starting Lambda runtime...")
    lambda.Start(handler)
}

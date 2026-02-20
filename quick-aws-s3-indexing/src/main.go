package main

import (
	"os"
	"log"
	"fmt"
	"context"
	"encoding/json"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"

	"github.com/mbasri/quick-aws-projects/quick-aws-s3-indexing/internal/models/data"
)

var (
	s3Client *s3.Client
	sqsClient *sqs.Client
	dynamodbClient *dynamodb.Client
	bucketName = os.Getenv("BUCKET_NAME")
	sqsQueueURL = os.Getenv("SQS_QUEUE_URL")
	dynamodbTable = os.Getenv("DYNAMODB_TABLE")
)

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load AWS SDK config, %v", err)
	}

	s3Client = s3.NewFromConfig(cfg)
	sqsClient = sqs.NewFromConfig(cfg)
	dynamodbClient = dynamodb.NewFromConfig(cfg)
	fmt.Printf("Initialized AWS clients: S3=%v, SQS=%v, DynamoDB=%v\n", s3Client, sqsClient, dynamodbClient)
}

func handler(ctx context.Context, event events.SQSEvent) () {
	
	fmt.Printf("Event: %s\n", event)
	

	for _, r := range event.Records {
		fmt.Printf("Record: %v\n", r)
		var s3Event events.S3Event
		var o *data.Object
		if err :=json.Unmarshal([]byte(r.Body), &s3Event); err == nil {
			o = data.NewObject(s3Event.Records[0].S3.Object.Key, s3Event.Records[0].S3.Object.Size, s3Event.Records[0].EventTime.String())
			fmt.Printf(o.String())
		} else {
			log.Printf("Error unmarshalling S3 event: %v", err)
		}
		fmt.Printf("Object: %v\n", o.String())

		sqsClient.DeleteMessage(ctx, &sqs.DeleteMessageInput{
			QueueUrl: &sqsQueueURL,
			ReceiptHandle: &r.ReceiptHandle,
		})
		
	}
}

func main() {
	fmt.Println("Starting Lambda runtime...")
	lambda.Start(handler)
}

package main

import (
	"context"
	"fmt"
	"github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
	Name string `json:"name"`
	Age int `json:"age"`
}

type MyResponse struct {
	Message string `json:"message"`
}



func handler(ctx context.Context, event MyEvent) (MyResponse, error) {
	if event.Age >= 30 {
			fmt.Println("Welcome to Lambda function Latest Version")
			return MyResponse{
				Message: fmt.Sprintf("Hello, %s!", event.Name),
			}, nil
	} else {
		return MyResponse{
			Message: fmt.Sprintf("Try Later %s", event.Name),
		}, nil
	}
}

func main() {
	lambda.Start(handler)
}

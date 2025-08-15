package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/nuonco/demo/aws-lambda/src/components/api/internal/dynamodb"
	"github.com/nuonco/demo/aws-lambda/src/components/api/internal/logging"
	"github.com/nuonco/demo/aws-lambda/src/components/api/internal/widget"
)

var logger = logging.DefaultLogger

func response(statusCode int, body string, err error) (events.APIGatewayProxyResponse, error) {
	if err != nil {
		logger.Println(err.Error())
		body = http.StatusText(statusCode)
	}

	return events.APIGatewayProxyResponse{
		StatusCode: statusCode,
		Body:       body,
	}, err
}

func get(event events.APIGatewayV2HTTPRequest) (events.APIGatewayProxyResponse, error) {
	id := event.PathParameters["id"]
	if _, err := strconv.Atoi(id); err != nil {
		return response(http.StatusBadRequest, "", err)
	}

	widget, err := dynamodb.GetItem(id, "widgets")
	if err != nil {
		return response(http.StatusInternalServerError, "", err)
	}
	if widget == nil {
		return response(http.StatusNotFound, "", err)
	}

	js, err := json.Marshal(widget)
	if err != nil {
		return response(http.StatusInternalServerError, "", err)
	}

	return response(http.StatusOK, string(js), nil)
}

func post(event events.APIGatewayV2HTTPRequest) (events.APIGatewayProxyResponse, error) {
	w := widget.Widget{}
	err := json.Unmarshal([]byte(event.Body), &w)
	if err != nil {
		return response(http.StatusUnprocessableEntity, "", err)
	}

	if _, err := strconv.Atoi(w.ID); err != nil {
		return response(http.StatusBadRequest, "", err)
	}

	err = dynamodb.PutItem(w.ID, "widgets")
	if err != nil {
		return response(http.StatusInternalServerError, "", err)
	}

	return response(http.StatusOK, "", nil)
}

func router(event events.APIGatewayV2HTTPRequest) (events.APIGatewayProxyResponse, error) {
	logger.Printf("event: %+v", event)
	method := event.RequestContext.HTTP.Method
	switch method {
	case "GET":
		return get(event)
	case "POST":
		return post(event)
	default:
		return response(http.StatusMethodNotAllowed, "", fmt.Errorf("method %s not allowed", method))
	}
}

func main() {
	lambda.Start(router)
}

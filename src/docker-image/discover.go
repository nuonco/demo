package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/nuonco/guides/aws-ecs-tutorial/components/docker-image/internal/introspection"
)

type discoverEndpoint struct {
	Path        string `json:"path"`
	Description string `json:"description"`
}

type discoverResponse struct {
	Description string             `json:"description"`
	Endpoints   []discoverEndpoint `json:"endpoints"`
}

func discoverHandler(ctx *gin.Context) {
	resp := &discoverResponse{
		Description: "This api exposes introspection details of a Nuon app running in a customer's cloud account.",
		Endpoints: []discoverEndpoint{
			{
				Description: introspection.EnvDescription,
				Path:        "/introspect/env",
			},
			{
				Description: introspection.NuonDescription,
				Path:        "/introspect/nuon",
			},
			{
				Description: "/livez check",
				Path:        "/livez",
			},
			{
				Description: "/readyz check",
				Path:        "/readyz",
			},
		},
	}

	ctx.JSON(http.StatusOK, resp)
}

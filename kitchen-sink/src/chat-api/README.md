# Chat API

## Running locally

1. proxy the remote deepseek api
2. set env vars
3. profit?

```
kubectl port-forward svc/deepseek-chatbot-service -n deepseek 8080:80
# in another window
uv sync
uv run --env-file .env python main.py
```

## ENV

```txt
DEBUG=False
HOST="0.0.0.0"
PORT=9021
ENV="dev"
DEEPSEEK_API_URL="http://localhost:8080"
DATABASE_URL="psql://localhost:5432/chatapi"
CLICKHOUSE_HOST='clickhouse-pv-simple.default.svc.cluster.local'
CLICKHOUSE_PORT=9000
CLICKHOUSE_USERNAME="chat_api"
CLICKHOUSE_PASSWORD="chat_api"
```

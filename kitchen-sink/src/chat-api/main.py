# a simple chat api that wraps the deepseek api and
# stores chats in RDS and clickhouse

import logging
import time

import httpx
from clickhouse import Clickhouse
from config import Config
from ksuid import Ksuid
from orjson import dumps
from proxy import DeepseekClient
from sanic import Sanic
from sanic.response import json, text

app = Sanic("ChatAPI")
config = Config()
clickhouse = Clickhouse()


@app.get("/ping")
async def ping(request):
    return json(dict(message="pong"))


@app.get("/live")
async def live(request):
    return json(dict(message="you bet"))


@app.get("/health")
async def health(request):
    return json(dict(message="let me check"))


@app.post("/api/v1/<path:path>")
async def chat_api_proxy(request, path):
    """
    proxy requests to the upstream deepseek api.
    capture request in a clickhouse table to enable chat replay/history.
    """
    request_id = str(Ksuid())
    client = DeepseekClient()
    start = time.time()
    response = await client.proxy(request)
    payload = response.json()
    execution_time = time.time() - start
    if response.status_code == 200:
        clickhouse.save_response(payload, request_id, execution_time)
    return json(payload, response.status_code)


@app.get("/ch/responses")
async def ch_responses(request):
    responses = clickhouse.get_responses()
    return json(responses, dumps=dumps)


if __name__ == "__main__":
    logger = logging.getLogger(__name__)
    logger.warning(f"*** Preparing to start: {app}")

    port = config.get("PORT")
    environment = config.get("ENVIRONMENT")
    debug = config.get("DEBUG")
    log_level = config.get("LOG_LEVEL")

    logger.warning(f"       port: {port}")
    logger.warning(f"        env: {environment}")
    logger.warning(f"      debug: {debug}")
    logger.warning(f"  log_level: {log_level}")

    assert not (
        debug and environment != "dev"
    ), "DEBUG should only ever be true in dev."

    clickhouse.ch_migrate()

    app.run(
        host=config.HOST,
        port=config.PORT,
        access_log=debug,
        dev=(environment == "dev" and debug),
        workers=2,
    )

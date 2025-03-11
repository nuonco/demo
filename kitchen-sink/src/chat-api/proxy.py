import logging

import httpx
from config import Config

config = Config()


class DeepseekClient:

    logger = logging.getLogger("DeepseekClient")

    async def proxy(self, request, timeout=300):
        """
        Async HTTP Proxy w/ high default read timeout
        Note: does not handle streaming since its use-case is scripting
        """
        path = request.path.split("/api/")[1]
        url = f"{config.DEEPSEEK_API_URL}/{path}"
        self.logger.warn(f"[proxy] {request.method} {request.url} -> {url}")

        timeout = httpx.Timeout(300.0, connect=300.0, read=timeout)
        async with httpx.AsyncClient(timeout=timeout) as client:
            request = httpx.Request(
                request.method,
                url,
                headers=request.headers,
                content=request.body or None,
            )
            response = await client.send(request)
        return response

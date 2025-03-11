from datetime import datetime

from clickhouse_driver import Client
from config import Config

config = Config()


class Clickhouse:

    _ch_client = None

    @property
    def ch_client(self):
        if self._ch_client:
            return self._ch_client

        # make a client
        client = Client(
            config.CLICKHOUSE_HOST,
            port=config.CLICKHOUSE_PORT,
            user=config.CLICKHOUSE_USERNAME,
            password=config.CLICKHOUSE_PASSWORD,
            database="chat_api",
        )
        self._ch_client = client
        return self._ch_client

    def ch_migrate(self):
        # overlaoded , i know
        client = self.ch_client
        with open(config.BASE_DIR / "sql" / "clickhouse.sql", "r") as openfile:
            migration_sql = openfile.read()
        client.execute(migration_sql)
        query_result = client.execute("show tables")
        for table in query_result[0]:
            print(f">  ch table: {table}")

    def save_response(self, payload: dict, request_id: str, execution_time: int):
        id = payload["id"]
        object_ = payload["object"]
        model = payload["model"]
        timestamp = datetime.fromtimestamp(payload.get("created"))
        usage_prompt_tokens = payload["usage"]["prompt_tokens"]
        usage_total_tokens = payload["usage"]["total_tokens"]
        usage_completion_tokens = payload["usage"]["completion_tokens"]

        self.ch_client.execute(
            f"""INSERT INTO chat_api.responses
            (request_id, id, object, model, timestamp, execution_time,
            usage.prompt_tokens, usage.total_tokens, usage.completion_tokens)
            VALUES(
                '{request_id}','{id}', '{object_}', '{model}', '{timestamp}', '{execution_time}',
                '{usage_prompt_tokens}', '{usage_total_tokens}', '{usage_completion_tokens}'
            )"""
        )

    def get_responses(self):
        response = self.ch_client.execute("SELECT * from chat_api.responses;")
        return response

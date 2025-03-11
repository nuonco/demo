from pathlib import Path

# import clickhouse_connect
import environ

BASE_DIR = Path(__file__).resolve().parent
env = environ.Env(
    # set casting, default value
    DEBUG=(bool, False),
    HOST=(str, "localhost"),
    PORT=(int, 9021),
    ENV=(str, "prod"),
    DEEPSEEK_API_URL=(str, "http://localhost:8080"),
    DATABASE_URL=(str, "psql://postgres:postgres@postgres:5432/postgres"),
    CLICKHOUSE_HOST=(str, "host.docker.internal"),
    CLICKHOUSE_PORT=(int, 9000),
    CLICKHOUSE_USERNAME=(str, "chat_api"),
    CLICKHOUSE_PASSWORD=(str, "chat_api"),
)

# reading .env file
environ.Env.read_env()


# convenience
class Config:
    BASE_DIR = BASE_DIR
    ENV = ENVIRONMENT = env("ENV")
    DEBUG = env("DEBUG")
    HOST = env("HOST")
    PORT = env("PORT")
    DEEPSEEK_API_URL = env("DEEPSEEK_API_URL")
    DATABASE_URL = env("DATABASE_URL")
    DATABASE = env.db()  # expects DATABASE_URL
    CLICKHOUSE_HOST = env("CLICKHOUSE_HOST")
    CLICKHOUSE_PORT = env("CLICKHOUSE_PORT")
    CLICKHOUSE_USERNAME = env("CLICKHOUSE_USERNAME")
    CLICKHOUSE_PASSWORD = env("CLICKHOUSE_PASSWORD")

    def __init__(self):
        self.LISTEN_ON = f"{self.HOST}:{self.PORT}"
        self.LOG_LEVEL = "debug" if self.DEBUG else "info"

    def get(self, value):
        return getattr(self, value.upper())

    @property
    def ch_client(self):
        if self._ch_client:
            return self._ch_client

        # make a client
        client = Client(
            self.CLICKHOUSE_HOST,
            port=self.CLICKHOUSE_PORT,
            user=self.CLICKHOUSE_USERNAME,
            password=self.CLICKHOUSE_PASSWORD,
            database="chat_api",
        )
        self._ch_client = client
        return self._ch_client

    def ch_migrate(self):
        # overlaoded , i know
        client = self.ch_client
        with open(BASE_DIR / "sql" / "clickhouse.sql", "r") as openfile:
            migration_sql = openfile.read()
        client.execute(migration_sql)
        query_result = client.execute("show tables")
        for table in query_result[0]:
            print(f" > ch table: {table}")

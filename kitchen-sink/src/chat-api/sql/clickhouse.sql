CREATE TABLE IF NOT EXISTS chat_api.responses
(
    `request_id` String,
    `id` String,
    `object` String,
    `model` String,
    `timestamp`  DateTime,
    `execution_time` DateTime64(3),
    `usage.prompt_tokens` Int16,
    `usage.total_tokens` Int16,
    `usage.completion_tokens` Int16
)
PARTITION BY toDate(timestamp)
PRIMARY KEY (model, request_id, timestamp)
ORDER BY (model, request_id, timestamp)

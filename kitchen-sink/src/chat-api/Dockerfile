FROM python:3.13-bookworm

RUN apt update && apt install -y gcc && pip install -U pip uv

WORKDIR /app

COPY . /app/

RUN uv sync

CMD ["uv", "run", "python", "main.py"]

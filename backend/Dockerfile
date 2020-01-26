FROM python:3.7.6-alpine3.11 as base

ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONBUFFERED=1

WORKDIR /app

FROM base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.0.2

# RUN apk add --no-cache gcc libffi-dev musl-dev postgresql-dev
RUN apk add --no-cache gcc libc-dev libffi-dev openssl-dev
RUN pip install "poetry==$POETRY_VERSION"
RUN python -m venv /venv

COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt | /venv/bin/pip install -r /dev/stdin

COPY . .
RUN poetry build && /venv/bin/pip install dist/*.whl

FROM builder as final

# RUN apk add --no-cache libffi libpq gcc
COPY --from=builder /venv /venv
COPY docker-entrypoint.sh ./
CMD ["./docker-entrypoint.sh"]
# --- Dependencies ---
FROM bitwalker/alpine-elixir-phoenix:1.10.3 AS deps
WORKDIR /app
COPY mix.exs mix.lock ./
RUN MIX_ENV=prod mix do deps.get --only prod, deps.compile

# --- Build ---
FROM bitwalker/alpine-elixir-phoenix:1.10.3 AS build

ENV ET_DB_USER=${ET_DB_USER}
ENV ET_DB_PASS=${ET_DB_PASS}
ENV ET_READ_DB=${ET_READ_DB}
ENV ET_EVENT_DB=${ET_EVENT_DB}
ENV ET_DB_HOST=${ET_DB_HOST}
ENV ET_DB_POOL_SIZE=${ET_DB_POOL_SIZE}
ENV ET_SECRET_KEY_BASE=${ET_SECRET_KEY_BASE}
ENV ET_DNS_ADDR=${ET_DNS_ADDR}
ENV ET_HTTP_PORT=${ET_HTTP_PORT}

WORKDIR /app
COPY . .
COPY --from=deps /app ./
RUN MIX_ENV=prod mix do phx.digest, release --overwrite

# --- Run ---
FROM alpine:latest
RUN apk update && apk --no-cache --update add bash openssl

ENV ET_DB_USER=${ET_DB_USER}
ENV ET_DB_PASS=${ET_DB_PASS}
ENV ET_READ_DB=${ET_READ_DB}
ENV ET_EVENT_DB=${ET_EVENT_DB}
ENV ET_DB_HOST=${ET_DB_HOST}
ENV ET_DB_POOL_SIZE=${ET_DB_POOL_SIZE}
ENV ET_SECRET_KEY_BASE=${ET_SECRET_KEY_BASE}
ENV ET_DNS_ADDR=${ET_DNS_ADDR}
ENV ET_HTTP_PORT=${ET_HTTP_PORT}

WORKDIR /app
COPY --from=build /app/_build/prod/rel/expense_tracker .

ENTRYPOINT ["bin/expense_tracker"]
CMD ["start"]
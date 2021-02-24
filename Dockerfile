# --- Dependencies ---
FROM bitwalker/alpine-elixir-phoenix:1.10.3 AS deps
ENV MIX_ENV=prod
WORKDIR /app
COPY mix.exs mix.lock ./
RUN mix do deps.get --only prod, deps.compile

# --- Build ---
FROM bitwalker/alpine-elixir-phoenix:1.10.3 AS build
ENV MIX_ENV=prod
WORKDIR /app
COPY . .
COPY --from=deps /app ./

RUN MIX_ENV=prod mix do phx.digest, release --overwrite

# --- Run ---
FROM alpine:latest
ENV MIX_ENV=prod
RUN apk update && apk --no-cache --update add bash openssl
WORKDIR /app
COPY --from=build /app/_build/prod/rel/expense_tracker .

ENTRYPOINT ["bin/expense_tracker"]
CMD ["start"]
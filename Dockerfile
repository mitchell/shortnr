FROM elixir:1.10 as build

WORKDIR /shortnr
COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force

ENV MIX_ENV prod
RUN mix clean --deps
RUN mix release

FROM debian:stable-20191224-slim

WORKDIR /shortnr
COPY --from=build /shortnr/_build/prod/rel/shortnr/ .

RUN apt-get update && apt-get install -y --no-install-recommends \
    libtinfo5=6.1+20181013-2+deb10u2 \
    openssl=1.1.1d-0+deb10u2 \
    locales=2.28-10 \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN groupadd -r shortnr && useradd --no-log-init -r -g shortnr shortnr
RUN chown -R shortnr:shortnr /shortnr
USER shortnr

ENTRYPOINT ["bin/shortnr", "start"]
EXPOSE 8080

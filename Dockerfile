FROM elixir:1.9-slim as build

WORKDIR /root/shortnr/service
COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force

RUN env MIX_ENV=prod mix release

FROM debian:buster-20191014-slim

WORKDIR /home/shortnr
COPY --from=build /root/shortnr/service/_build/prod/rel/service/ .

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
RUN chown -R shortnr:shortnr /home/shortnr
USER shortnr

ENTRYPOINT ["bin/service", "start"]
EXPOSE 8080

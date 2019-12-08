.PHONY: all build clean install start test

build: install test clean
	docker build -t shortnr:latest .

clean:
	mix clean --deps

install:
	mix deps.get

install-prod:
	mix deps.get --only prod

start:
	iex -S mix run --no-halt

test:
	mix test

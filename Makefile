.PHONY: all build clean install lint start test

build: install lint test clean
	docker build -t shortnr:latest .

clean:
	mix clean

install:
	mix deps.get

lint:
	mix dialyzer
	mix credo --strict

start:
	iex -S mix run --no-halt

test:
	mix test

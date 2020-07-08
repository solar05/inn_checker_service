run:
	mix phx.server
deps:
	mix deps.get
compile:
	mix compile
format-check:
	mix format mix.exs "lib/**/*.{ex,exs}" "priv/**/*.{ex,exs}" "test/**/*.{ex,exs}" --check-formatted
format:
	mix format mix.exs "lib/**/*.{ex,exs}" "priv/**/*.{ex,exs}" "test/**/*.{ex,exs}"
tests:
	mix test

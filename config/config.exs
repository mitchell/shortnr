import Config

config :shortnr,
  port: 8080,
  ets_implementation: :dets

config :logger, :console,
  format: "date=$date time=$time level=$level$levelpad message=\"$message\" $metadata\n",
  metadata: [:port, :file, :line, :crash_reason, :stack],
  level: :debug

config :credo,
  checks: [
    # Ignore these checks because they don't apply to the projects Elixir version
    {Credo.Check.Refactor.MapInto, false},
    {Credo.Check.Warning.LazyLogging, false}
  ]

import_config "#{Mix.env}.exs"

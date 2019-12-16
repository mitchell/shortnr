import Config

config :service,
  port: 8080

config :logger, :console,
  format: "date=$date time=$time level=$level$levelpad message=\"$message\" $metadata\n",
  metadata: [:port, :file, :line, :crash_reason, :stack],
  level:
    (fn
       :prod -> :info
       _ -> :debug
     end).(Mix.env())

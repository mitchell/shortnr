defmodule Shortnr.MixProject do
  use Mix.Project

  def project do
    [
      app: :shortnr,
      description: "A small & simple url shortener",
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      dialyzer: [ignore_warnings: "dialyzer.ignore-warnings"],
      deps: deps(),
      aliases: aliases(),
      releases: [
        shortnr: [
          include_executables_for: [:unix],
          applications: [shortnr: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Shortnr.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0"},
      {:elixir_uuid, "~> 1.2"},
      {:dialyxir, "~> 0.5.1", only: [:dev], runtime: false},
      {:credo, "~> 1.1.5", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp aliases do
    [
      build: &docker_build/1,
      lint: ["compile", "dialyzer", "credo --strict"],
      "infra.apply": &infra_apply/1,
      "infra.plan": &infra_plan/1,
      "infra.destroy": &infra_destroy/1
    ]
  end

  defp infra_apply(_) do
    if Mix.shell().yes?("Are you sure you want to apply? (Have you run plan?)") do
      0 = Mix.shell().cmd("cd ./infra && terraform validate && terraform apply -auto-approve")
    end
  end

  defp infra_destroy(_) do
    if Mix.shell().yes?("Are you sure you want to destroy?") do
      0 = Mix.shell().cmd("cd ./infra && terraform validate && terraform destroy -auto-approve")
    end
  end

  defp infra_plan(_) do
    0 = Mix.shell().cmd("cd ./infra && terraform validate && terraform plan")
  end

  defp docker_build(_) do
    0 = Mix.shell().cmd("docker build -t shortnr:latest .")
  end
end

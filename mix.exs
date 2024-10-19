defmodule SkillSanity.MixProject do
  use Mix.Project

  @version "1.0.0-alpha.6"
  def project do
    [
      app: :skill_sanity,
      version: @version,
      elixir: "~> 1.17.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SkillSanity.Application, []},
      extra_applications: [:logger, :logger_backends, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:ash, "== 3.4.33"},
      {:ash_appsignal, "== 0.1.3"},
      {:picosat_elixir, "== 0.2.3"},
      {:ash_postgres, "== 2.4.9"},
      {:ash_phoenix, "== 2.1.6"},
      {:appsignal, "== 2.13.0"},
      {:appsignal_phoenix, "== 2.5.0"},
      {:logfmt_ex, "== 0.4.2"},
      {:logger_backends, "== 1.0.0"},
      {:phoenix, "== 1.7.14"},
      {:phoenix_ecto, "== 4.6.2"},
      {:ecto_sql, "== 3.12.1"},
      {:nimble_csv, "== 1.2.0"},
      {:postgrex, "== 0.19.1"},
      {:phoenix_html, "== 4.1.1"},
      {:phoenix_live_reload, "== 1.5.3", only: :dev},
      # TODO: bump on release to {:phoenix_live_view, "~> 1.0.0"},
      {:phoenix_live_view, "== 1.0.0-rc.7", override: true},
      {:slugify, "== 1.3.1"},
      {:floki, "== 0.36.2", only: :test},
      {:phoenix_live_dashboard, "== 0.8.4"},
      {:esbuild, "== 0.8.2", runtime: Mix.env() == :dev},
      {:tailwind, "== 0.2.4", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.5",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:swoosh, "== 1.17.2"},
      {:finch, "== 0.19.0"},
      {:telemetry_metrics, "== 1.0.0"},
      {:telemetry_poller, "== 1.1.0"},
      {:gettext, "== 0.26.1"},
      {:jason, "== 1.4.4"},
      {:dns_cluster, "== 0.1.3"},
      {:bandit, "== 1.5.7"},
      {:yaml_elixir, "== 2.11.0"},

      # dev/test
      {:dialyxir, "== 1.4.4", only: [:dev, :test], runtime: false},
      {:semantic_release, "== 1.0.0-alpha.7", only: :dev, runtime: false}
    ]
  end

  defp dialyzer() do
    [
      plt_local_path: "priv/plts/project.plt",
      plt_core_path: "priv/plts/core.plt"
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind skill_sanity", "esbuild skill_sanity"],
      "assets.deploy": [
        "tailwind skill_sanity --minify",
        "esbuild skill_sanity --minify",
        "phx.digest"
      ]
    ]
  end
end

defmodule FarmbotCore.MixProject do
  use Mix.Project
  @target System.get_env("MIX_TARGET") || "host"
  @version Path.join([__DIR__, "..", "VERSION"])
           |> File.read!()
           |> String.trim()
  @branch System.cmd("git", ~w"rev-parse --abbrev-ref HEAD")
          |> elem(0)
          |> String.trim()
  # @elixir_version Path.join([__DIR__, "..", "ELIXIR_VERSION"])
  #                 |> File.read!()
  #                 |> String.trim()

  defp commit do
    System.cmd("git", ~w"rev-parse --verify HEAD") |> elem(0) |> String.trim()
  end

  def project do
    [
      app: :farmbot_core,
      description: "The Brains of the Farmbot Project",
      # elixir: @elixir_version,
      elixirc_options: [warnings_as_errors: true, ignore_module_conflict: true],
      make_clean: ["clean"],
      make_cwd: __DIR__,
      compilers: [:elixir_make] ++ Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      version: @version,
      target: @target,
      branch: @branch,
      commit: commit(),
      build_embedded: false,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      source_url: "https://github.com/Farmbot/farmbot_os",
      homepage_url: "http://farmbot.io",
      docs: [
        logo: "../farmbot_os/priv/static/farmbot_logo.png",
        extras: Path.wildcard("../docs/**/*.md")
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :runtime_tools],
      mod: {FarmbotCore, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:farmbot_celery_script,
       path: "../farmbot_celery_script", env: Mix.env()},
      {:farmbot_firmware, path: "../farmbot_firmware", env: Mix.env()},
      {:farmbot_telemetry, path: "../farmbot_telemetry", env: Mix.env()},
      {:elixir_make, "~> 0.6.2", runtime: false},
      {:sqlite_ecto2, "~> 2.3"},
      {:timex, "~> 3.6.3"},
      {:jason, "~> 1.2.2"},
      {:muontrap, "~> 0.6"},
      {:excoveralls, "~> 0.13.4", only: [:test], targets: [:host]},
      {:mimic, "~> 1.4.0", only: [:test]},
      {:ex_doc, "~> 0.23.0", only: [:dev], targets: [:host], runtime: false}
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", Path.expand("../test/support")]
  end

  defp elixirc_paths(:dev) do
    ["lib", Path.expand("../test/support")]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp aliases,
    do: [
      test: [
        "ecto.drop",
        "ecto.migrate",
        "test"
      ]
    ]
end

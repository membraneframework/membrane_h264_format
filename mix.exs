defmodule Membrane.H264.Mixfile do
  use Mix.Project

  @version "0.3.0"
  @github_url "https://github.com/membraneframework/membrane_h264_format"

  def project do
    [
      app: :membrane_h264_format,
      version: @version,
      elixir: "~> 1.13",
      description: "Membrane Multimedia Framework (H264 video format definition)",
      package: package(),
      name: "Membrane H264 Format",
      source_url: @github_url,
      docs: docs(),
      deps: deps(),
      dialyzer: dialyzer()
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "LICENSE"],
      source_ref: "v#{@version}"
    ]
  end

  defp dialyzer() do
    opts = [
      flags: [:error_handling]
    ]

    if System.get_env("CI") == "true" do
      # Store PLTs in cacheable directory for CI
      [plt_local_path: "priv/plts", plt_core_path: "priv/plts"] ++ opts
    else
      opts
    end
  end

  defp package do
    [
      maintainers: ["Membrane Team"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => @github_url,
        "Membrane Framework Homepage" => "https://membraneframework.org"
      }
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: :dev, runtime: false}
    ]
  end
end

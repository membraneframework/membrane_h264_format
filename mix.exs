defmodule Membrane.Caps.Video.H264.Mixfile do
  use Mix.Project

  @version "0.2.0"
  @github_url "https://github.com/membraneframework/membrane-caps-video-h264"

  def project do
    [
      app: :membrane_caps_video_h264,
      version: @version,
      elixir: "~> 1.7",
      description: "Membrane Multimedia Framework (H264 video format definition)",
      package: package(),
      name: "Membrane Caps: Video H264",
      source_url: @github_url,
      docs: docs(),
      deps: deps()
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
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

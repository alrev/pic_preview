defmodule PicPreview.Mixfile do
  use Mix.Project

  def project do
    [app: :pic_preview,
     version: "0.1.0",
     elixir: "~> 1.4",
     escript: escript(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def escript do
    [main_module: PicPreview]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    # :fastimage can be deleted in Elixir 1.4+ (mix 1.4+)
    [extra_applications: [:logger, :fastimage]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
    {:httpoison, "~> 0.11.1"},
    {:floki, "~> 0.16.0"},
    {:fastimage, "~> 0.0.7"}
    ]
  end
end

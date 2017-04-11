defmodule App do
  use Application

  def start(_, _) do
    # import Supervisor.Spec

    children =
    [
      Plug.Adapters.Cowboy.child_spec(:http, Web, [], [port: 8080])
    ]

    opts = [strategy: :one_for_one, name: App.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
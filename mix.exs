defmodule Updtr.MixProject do
  use Mix.Project

  def project do
    [
      app: :updtr,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Updtr.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.4.11"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:guardian, "~> 2.0"},
      {:bamboo, "~> 1.3"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

# <!DOCTYPE html>
# <html lang="en">
#   <head>
#     <meta charset="utf-8"/>
#     <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
#     <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
#     <title>Updtr</title>
#     <link rel="stylesheet" href="<%= Routes.static_path(@conn, "/css/app.css") %>"/>
#   </head>
#   <body>
#     <main role="main" class="container">
#       <p class="alert alert-info" role="alert"><%= get_flash(@conn, :info) %></p>
#       <p class="alert alert-danger" role="alert"><%= get_flash(@conn, :error) %></p>
#       <%= render @view_module, @view_template, assigns %>
#     </main>
#     <script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/app.js") %>"></script>
#   </body>
# </html>

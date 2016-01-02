use Mix.Config

config :marvin, bots: [Slacker.Hearth]

import_config "#{Mix.env}.exs"

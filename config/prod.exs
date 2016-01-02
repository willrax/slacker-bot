use Mix.Config

config :marvin, slack_token: System.get_env("SLACK_TOKEN")
config :probot, mashape_key: System.get_env("MASHAPE_KEY")

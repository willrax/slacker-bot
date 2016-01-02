defmodule Slacker.Hearth do
  use Marvin.Bot

  require IEx

  match ~r/^hearth/

  def handle_ambient(message, slack) do
    "hearth " <> query = message.text

    case fetch_card(query) do
      {:error, reason} ->
        send_message(reason, message.channel, slack)

      attachment ->
        send_attachment(attachment, message.channel, slack)
    end
  end

  def fetch_card(query) do
    url = "https://omgvamp-hearthstone-v1.p.mashape.com/cards/search/#{query}"
    |> URI.encode

    header_map = %{"X-Mashape-Key": Application.get_env(:probot, :mashape_key)}

    case HTTPoison.get(url, header_map) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        card = body
          |> to_string
          |> JSX.decode
          |> format_attachment

      {:error, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Card not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def format_attachment({:ok, cards}) do
    card = List.first(cards)

    [
      %{
        color: "#d9edf7",
        text: "<#{card["img"]}|#{card["name"]}>",
        image_url: card["imgGold"],
        fields: [
          %{ title: "Set", value: card["cardSet"], short: true },
          %{ title: "Type", value: card["type"], short: true }
        ]
      }
    ]
  end
end

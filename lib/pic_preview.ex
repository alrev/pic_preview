defmodule PicPreview do
  @moduledoc """
  This module can create picture preview for a given url.
  """

  @doc """
  Main function for the service.
  """
  def main(args \\ []) do
    {parsed, _, _} = OptionParser.parse(args, switches: [url:  :string])
    # IO.puts("Hello #{parsed[:mode]}")
    html = get_page(parsed[:url])
    head_only = html |> Floki.find("head") |> Floki.raw_html
    pics = find_picture_candidates(head_only, parsed[:url])
    pics = case (length(pics) >= 2) do
      true -> pics
      false -> find_picture_candidates(html, parsed[:url])
    end
    # IO.inspect pics
    pic = Enum.reduce(pics, {"", 1, 1}, fn(x, acc) ->
      # Fastimage downloads only the necessary amount of data to get dimensions size
      {height, width} = List.to_tuple(Map.values(Fastimage.size(x)))
      cond do
        width > elem(acc, 1) -> {x, width, height}
        true -> acc
      end
    end)
    # thumbnex (https://github.com/talklittle/thumbnex) can be used for futher optimization of the image
    IO.inspect pic
  end

  # Try to get html of the given url.
  defp get_page(url) do
    # follow_redirect argument goes futher if 302 or 301 code was received
    case HTTPoison.get(url, [], [follow_redirect: true]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        # this situation should be handled in a proper way
        IO.puts "Couldn\'t Load #{url}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        # this situation should be handled in a proper way
        IO.inspect reason
    end
  end

  # Try to find links to pictures which are possible good candidates for the preview.
  # Returns list of urls to pictures.
  defp find_picture_candidates(html, url) do
    pics = find_pictures(html)
    # convert relative urls to the absolute ones
    pics = Enum.map(pics, fn(x) ->
           case String.first(x) do
             "/" -> url <> x
             _ -> x
           end
         end
    )
    filter_by_keyword(pics)
    #has_http_scheme = String.slice(url, 0, 4) == "http"
    #hostname = case has_http_scheme do
    #  true -> String.split(url, "/") |> Enum.at(2)
    #  false -> String.split(url, "/") |> List.first
    #end
    # apply additional filter: check whether any pictures has hostname in picture name
  end

  # apply additional filter based on key words: icon, logo
  defp filter_by_keyword(pics) do
    # more or less widespread: having "icon", "logo" in the name of the file which suits well
    # or "app", "ios" in the file name (https://slack.com)
    in_filename = Enum.any?(pics, fn(x) ->
                         filename = List.last(String.split(x, "/"))
                         String.contains?(filename, ["icon", "logo", "app", "ios"])
                       end)
    case in_filename do
      true -> Enum.filter(pics, fn(x) ->
                filename = List.last(String.split(x, "/"))
                String.contains?(filename, ["icon", "logo", "app", "ios"])
              end)
      false ->
        in_path = Enum.any?(pics, &(String.contains?(&1, ["icon", "logo"])))
        case in_path do
         true -> Enum.filter(pics, &(String.contains?(&1, ["icon", "logo"])))
         false -> pics
        end
    end
  end

  # get pictures in bmp, jpeg, png, gif (supported by fastimage module).
  defp find_pictures(html) do
    filter1(html) ++ filter2(html) ++ filter3(html)
    # delete query parameters from urls,
    # because some links (https://stackoverflow.com) do not end up with proper file extension
    |> Enum.map(&(List.first(String.split(&1, "?"))))
    |> Enum.filter(&(
                   (String.slice(&1, -4, 4) == ".png") or
                   (String.slice(&1, -5, 5) == ".jpeg") or
                   # bmp is rare
                   # (String.slice(&1, -4, 4) == ".bmp") or
                   (String.slice(&1, -4, 4) == ".gif")
                   ))
  end

  # there are several places for searching the picture for preview,
  # so several filters below are used to find the best
  # no templates for https://amazon.com currently, for example
  # this template suits https://github.com, https://stripe.com, https://slack.com, https://duckduckgo.com
  defp filter1(html) do
    html
    |> Floki.find("link")
    |> Floki.attribute("href")
  end
  # this template suits atom.io
  defp filter2(html) do
    html
    |> Floki.find("meta")
    |> Floki.attribute("content")
  end
  # this template suits http://elixir-lang.org
  defp filter3(html) do
    html
    |> Floki.find("img")
    |> Floki.attribute("src")
  end
end

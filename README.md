# PicPreview

PicPreview is a module for searching the most representative picture from a web site which can be used as a preview, in most cases this is a logo.

Currently tested for: https://virtualbox.com, https://stripe.com, https://slack.com, https://stackoverflow.com, https://github.com (can be improved), http://elixir-lang.org.

PicPreview.get_picture(url) returns {"link_to_the_picture", width, height}

The default Application (iex -S mix) is a server (port 8080) which can handle GET requests like "curl http://127.0.0.1:8080/pic_preview?url=https://www.youtube.com" and return as a response a "https://www.youtube.com/yts/img/favicon_144-vflWmzoXw.png".

## Known problems
Doesn't work with https://youtube.com (but fine with https://www.youtube.com), scmp.com (works well with www.scmp.com).

Doesn't work with google.com (https://github.com/edgurgel/httpoison/issues/240).

Does Fastimage (https://github.com/stephenmoloney/fastimage) need a scheme (doesn't work for "elixir-lang.org/images/logo/logo.png")?

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pic_preview` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:pic_preview, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pic_preview](https://hexdocs.pm/pic_preview).


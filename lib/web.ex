defmodule Web do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/pic_preview" do
    conn = Plug.Conn.fetch_query_params(conn)
    {url, _, _} = PicPreview.get_picture(conn.params["url"])
    Plug.Conn.send_resp(conn, 200, url)
  end

  match _ do
    Plug.Conn.send_resp(conn, 404, "not found")
  end
end
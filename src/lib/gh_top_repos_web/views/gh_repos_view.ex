defmodule GhTopReposWeb.GHReposView do
  use GhTopReposWeb, :view

  @doc """
  Provides a pagination method for templates.

  Given the `conn` and `total_count`, it calculates the
  previous, next and total pages to display.

  Also, generates the request path for next and previous
  pages, including que request query params.

  Returns `%{
     :page
     :total_pages
     :total_count ,
     :next_page
     :prev_page
     :next_path
     :prev_path
  }`
  """
  def pagination(conn, total_count \\ 0, page_size \\ 9) do
    p = conn.query_params["p"]
    page = if p do String.to_integer(p) else 1 end

    total_pages = ceiling(total_count / page_size)

    next_page = if page + 1 <= total_pages do page + 1 else nil end
    prev_page = if page - 1 > 0 do page - 1 else nil end

    %{
      page: page,
      total_pages: total_pages,
      total_count: total_count,
      next_page: next_page,
      prev_page: prev_page,
      next_path: build_query_str(conn, next_page),
      prev_path: build_query_str(conn, prev_page)
    }
  end

  # replaces the "p" parameter on query params map.
  defp build_query_str(conn, p) do
    if p do
      params = Map.put(conn.query_params, "p", p)
      conn.request_path <> "?" <> URI.encode_query(params)
    else
      nil
    end
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t
      pos when pos > 0 ->
        t + 1
      _ -> t
    end
  end
end

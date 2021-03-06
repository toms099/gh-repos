defmodule GhTopRepos.GithubClientTest do

  use ExUnit.Case, async: true

  alias GhTopRepos.GithubClient


  test "fetch repositories failed: bad query" do

    {:error, result} = GithubClient.fetch_repos([text: ""])

    [e | _] = result.errors
    assert e.code == "missing"
    assert e.field == "q"
    assert result.message == "Validation Failed"
  end


  test "fetch repositories succeeded" do
    query = [text: "elixir", stars: 200]
    {:ok, repos} = GithubClient.fetch_repos(query, 1, 2)

    assert length(repos.items) == 2
  end
end

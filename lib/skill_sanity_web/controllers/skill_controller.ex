defmodule SkillSanityWeb.SkillController do
  use SkillSanityWeb, :controller

  alias SkillSanity.Skills

  action_fallback SkillSanityWeb.FallbackController

  def search(conn, %{"skill" => search_term}) do
    {skill, confidence, variation} =
      search_term
      |> String.trim()
      |> Skills.search!()

    render(conn, :search_one, skill: skill, confidence: confidence, variation: variation)
  end

  def search(conn, %{"skills" => search_terms}) do
    results =
      search_terms
      |> String.split(",")
      |> Enum.map(fn search_term ->
        search_term
        |> String.trim()
        |> Skills.search!()
      end)

    render(conn, :search_many, results: results)
  end
end

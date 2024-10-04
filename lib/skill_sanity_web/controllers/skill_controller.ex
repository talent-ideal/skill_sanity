defmodule SkillSanityWeb.SkillController do
  use SkillSanityWeb, :controller

  alias SkillSanity.Skills

  action_fallback SkillSanityWeb.FallbackController

  def search(conn, %{"skill" => search_term}) do
    {skill, confidence, variation} = Skills.search_skill!(search_term)
    render(conn, :search_one, skill: skill, confidence: confidence, variation: variation)
  end

  def search(conn, %{"skills" => search_terms}) do
    search_terms =
      search_terms
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    results = Enum.map(search_terms, &Skills.search_skill(&1))

    render(conn, :search_many, results: results)
  end
end

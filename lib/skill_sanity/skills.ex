defmodule SkillSanity.Skills do
  use Ash.Domain

  alias __MODULE__
  alias Skills.Skill
  alias Skills.Variation

  require Ash.Query
  require Logger

  resources do
    resource Skills.Skill do
      define :create_skill, action: :create, args: [:slug, :name, :source]
    end

    resource Skills.Variation do
      define :create_variation, action: :create, args: [:skill_id, :variation, :source]
    end
  end

  @doc """
  Search for the best matching skill or variation based on similarity.

  Returns a `{skill, confidence, variation}` tuple when found, `nil` otherwise.
  """
  @spec search_skill(binary()) :: {Skill.t(), float(), Variation.t() | nil} | nil
  def search_skill(search_term) do
    skill_search_task =
      Task.async(fn -> Skill.search(search_term) end)

    variation_search_task =
      Task.async(fn -> Variation.search(search_term, load: [:skill]) end)

    skill_results = await_search_results(skill_search_task)
    variation_results = await_search_results(variation_search_task)

    mapped_skill_results =
      Enum.map(skill_results, fn skill ->
        %{
          similarity: skill.similarity,
          skill: skill,
          variation: nil
        }
      end)

    mapped_variation_results =
      Enum.map(variation_results, fn variation ->
        %{
          similarity: variation.similarity,
          skill: variation.skill,
          variation: variation
        }
      end)

    all_results = mapped_skill_results ++ mapped_variation_results

    if all_results == [] do
      nil
    else
      sorted_results =
        Enum.sort_by(all_results, & &1.similarity, :desc)

      best_match = List.first(sorted_results)

      {best_match.skill, round_similarity(best_match.similarity), best_match.variation}
    end
  end

  @spec search_skill!(binary()) :: {Skill.t(), float(), Variation.t() | nil}
  def search_skill!(search_term) do
    result = search_skill(search_term)

    result || raise "No matching skill found."
  end

  defp round_similarity(similarity), do: Float.round(similarity, 3)

  defp await_search_results(task) do
    case Task.await(task, 5000) do
      {:ok, results} ->
        results

      {:error, reason} ->
        Logger.error("Search task failed: #{inspect(reason)}")
        []

      _ ->
        []
    end
  end
end

defmodule SkillSanity.Skills do
  use Ash.Domain

  alias __MODULE__
  alias Skills.{Skill, Variation, SearchLog}

  require Ash.Query
  require Logger

  resources do
    resource Skill do
      define :create_skill, action: :create, args: [:slug, :name, :source]
      define :search_skill, action: :search, args: [:search_term]
    end

    resource Variation do
      define :create_variation, action: :create, args: [:skill_id, :variation, :source]
      define :search_variation, action: :search, args: [:search_term]
    end

    resource SearchLog do
      define :create_search_log,
        action: :create,
        args: [
          :search_term,
          {:optional, :confidence},
          {:optional, :matched_skill_id},
          {:optional, :matched_variation_id}
        ]
    end
  end

  @doc """
  Search for the best matching skill or variation based on similarity.

  Returns a `{skill, confidence, variation}` tuple when found, `nil` otherwise.
  """
  @spec search(binary()) :: {Skill.t(), float(), Variation.t() | nil} | nil
  def search(search_term) do
    skill_search_task =
      Task.async(fn -> Skills.search_skill(search_term) end)

    variation_search_task =
      Task.async(fn -> Skills.search_variation(search_term, load: [:skill]) end)

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

    result =
      case all_results do
        [] ->
          nil

        _ ->
          sorted_results =
            Enum.sort_by(all_results, & &1.similarity, :desc)

          best_match = List.first(sorted_results)

          {best_match.skill, round_similarity(best_match.similarity), best_match.variation}
      end

    log_search_async(search_term, result)

    result
  end

  @spec search!(binary()) :: {Skill.t(), float(), Variation.t() | nil}
  def search!(search_term) do
    result = search(search_term)

    result || raise "No matching skill found."
  end

  defp log_search_async(search_term, result) do
    Task.Supervisor.start_child(SkillSanity.SearchLogTaskSupervisor, fn ->
      try do
        log_search(search_term, result)
      rescue
        exception ->
          Logger.error("""
          Error in log_search_async for search term "#{search_term}":
          #{Exception.format(:error, exception, __STACKTRACE__)}
          """)

          reraise exception, __STACKTRACE__
      end
    end)
  end

  defp log_search(search_term, nil) do
    # No match found
    Skills.create_search_log(search_term)
  end

  defp log_search(search_term, {skill, confidence, nil}) do
    # Matched skill directly
    Skills.create_search_log(
      String.trim(search_term),
      confidence,
      skill.id
    )
  end

  defp log_search(search_term, {skill, confidence, variation}) do
    # Matched via variation
    Skills.create_search_log(
      String.trim(search_term),
      confidence,
      skill.id,
      variation.id
    )
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

defmodule SkillSanity.Skills do
  use Ash.Domain

  alias __MODULE__
  alias Skills.Skill
  alias Skills.Variation

  require Ash.Query

  resources do
    resource Skills.Skill do
      define :create_skill, action: :create, args: [:slug, :name, :source]
    end

    resource Skills.Variation do
      define :create_variation, action: :create, args: [:skill_id, :variation, :source]
    end
  end

  @doc """
  Search a skill by exact match on name or by best matching variation.

  Returns a `{skill, confidence}` tuple when found, `nil` otherwise.
  """
  @spec search_skill(binary()) :: {struct(), float(), struct() | nil} | nil
  def search_skill(search_term) do
    case Skill.search(search_term) do
      {:ok, [best | _] = results} when results != [] ->
        {best, round_similarity(best.similarity), nil}

      _ ->
        search_variation(search_term)
    end
  end

  defp search_variation(search_term) do
    case Variation.search(search_term, load: [:skill]) do
      {:ok, [best | _] = results} when results != [] ->
        {best.skill, round_similarity(best.similarity), best}

      _ ->
        nil
    end
  end

  defp round_similarity(similarity), do: Float.round(similarity, 3)

  @spec search_skill!(binary()) :: {struct(), float(), struct() | nil}
  def search_skill!(search_term) do
    result = search_skill(search_term)

    result || raise "No matching skill found."
  end
end

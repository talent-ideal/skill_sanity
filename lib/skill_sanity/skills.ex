defmodule SkillSanity.Skills do
  use Ash.Domain

  alias __MODULE__
  alias Skills.Skill
  alias Skills.Variation

  require Ash.Query

  resources do
    resource Skills.Skill do
      define :create_skill, action: :create, args: [:slug, :name]
    end

    resource Skills.Variation do
      define :create_variation, action: :create, args: [:skill_id, :variation]
    end
  end

  @doc """
  Search a skill by exact match on name or by best matching variation.

  Returns a `{skill, confidence}` tuple when found, `nil` otherwise.
  """
  @spec search_skill(binary()) :: {float(), struct()} | nil
  def search_skill(search_term) do
    case Skill.get_by_name(search_term) do
      {:ok, skill} ->
        {skill, 1}

      {:error, _} ->
        case Variation.search(search_term, load: [:skill]) do
          {:ok, [best | _] = results} when results != [] ->
            {best.skill, best.similarity}

          _ ->
            nil
        end
    end
  end
end

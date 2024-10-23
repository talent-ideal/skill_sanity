defmodule SkillSanityWeb.SkillJSON do
  alias SkillSanity.Skills.Skill
  alias SkillSanity.Skills.Variation

  @doc """
  Renders a single skill search result.
  """
  def search_one(%{result: result}) do
    %{data: data(result)}
  end

  @doc """
  Renders multiple skill search results.
  """
  def search_many(%{results: results}) do
    %{
      data: for(result <- results, do: data(result))
    }
  end

  defp data({%Skill{} = skill, confidence, nil})
       when is_number(confidence) do
    %{skill: data(skill), confidence: confidence, matched_variation: nil}
  end

  defp data({%Skill{} = skill, confidence, %Variation{} = variation})
       when is_number(confidence) do
    %{skill: data(skill), confidence: confidence, matched_variation: data(variation)}
  end

  defp data(%Skill{} = skill) do
    %{
      id: skill.id,
      name: skill.name,
      slug: skill.slug
    }
  end

  defp data(%Variation{} = variation) do
    %{
      id: variation.id,
      variation: variation.variation
    }
  end

  defp data(nil), do: nil
end

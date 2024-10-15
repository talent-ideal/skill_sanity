defmodule SkillSanity.SkillsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SkillSanity.Skills` context.
  """

  alias SkillSanity.Skills.Skill
  alias SkillSanity.Skills.Variation

  def skill_valid_attr(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: "React",
      slug:
        cond do
          Map.has_key?(attrs, :slug) -> attrs.slug
          Map.has_key?(attrs, :name) -> Slug.slugify(attrs.name)
          true -> "react"
        end,
      source: "test"
    })
  end

  def variation_valid_attr(attrs \\ %{}) do
    Enum.into(attrs, %{
      variation: "react.js",
      source: "test"
    })
  end

  def skill_fixture(attrs \\ %{}) do
    skill =
      attrs
      |> skill_valid_attr()
      |> Skill.create!(skip_unknown_inputs: :*)

    variation =
      attrs
      |> variation_valid_attr()
      |> then(fn attrs -> Variation.create!(skill.id, attrs, skip_unknown_inputs: :*) end)

    {skill, variation}
  end
end

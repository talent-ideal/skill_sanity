defmodule SkillSanity.Skills.SkillTest do
  use SkillSanity.DataCase, async: true

  use ExUnitProperties

  alias SkillSanity.Skills
  alias SkillSanity.Skills.Skill

  # generates random skill names (e.g. "Ip5n64LV7dD MO 547RI")
  defp name do
    gen all(
          parts <-
            list_of(string(:alphanumeric, min_length: 2, max_length: 15),
              min_length: 1,
              max_length: 5
            )
        ) do
      Enum.join(parts, " ")
    end
  end

  defp extract_args(input) do
    {name, slug, source} = {input.name, Slug.slugify(input.name), input.source}
    other_inputs = Map.drop(input, [:name, :slug, :source])

    {name, slug, source, other_inputs}
  end

  describe "valid inputs" do
    # now if our action inputs are invalid when we think they should be valid, we will find out here
    property "accepts all valid input" do
      check all(
              input <-
                Ash.Generator.action_input(Skill, :create, %{
                  name: name(),
                  slug: nil,
                  source: "test"
                })
            ) do
        {name, slug, source, other_inputs} = extract_args(input)

        assert Skills.changeset_to_create_skill(
                 slug,
                 name,
                 source,
                 other_inputs
               ).valid?
      end
    end

    # same as the above, but actually call the action. This tests the underlying action implementation
    # not just initial validation
    property "succeeds on all valid input" do
      check all(
              input <-
                Ash.Generator.action_input(Skill, :create, %{
                  name: name(),
                  slug: nil,
                  source: "test"
                })
            ) do
        {name, slug, source, other_inputs} = extract_args(input)

        Skills.create_skill!(slug, name, source, other_inputs)
      end
    end

    test "can create some specific skills, in addition to any other valid inputs" do
      Skills.create_skill!("javascript", "JavaScript", "test")
      Skills.create_skill!("react", "React", "test")
      Skills.create_skill!("angular-js", "AngularJS", "test")
    end
  end
end

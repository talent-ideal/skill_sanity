defmodule SkillSanity.Skills.VariationTest do
  use SkillSanity.DataCase, async: true

  alias SkillSanity.Skills

  describe "valid inputs" do
    test "can create valid variations" do
      skill = Skills.create_skill!("react", "React")

      Skills.create_variation!(skill.id, "ReactJS")
      Skills.create_variation!(skill.id, "React JS")
      Skills.create_variation!(skill.id, "react-js")
      Skills.create_variation!(skill.id, "react")
    end
  end
end

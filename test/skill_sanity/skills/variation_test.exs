defmodule SkillSanity.Skills.VariationTest do
  use SkillSanity.DataCase, async: true

  alias SkillSanity.Skills

  describe "valid inputs" do
    test "can create valid variations" do
      skill = Skills.create_skill!("react", "React", "test")

      Skills.create_variation!(skill.id, "ReactJS", "test")
      Skills.create_variation!(skill.id, "React JS", "test")
      Skills.create_variation!(skill.id, "react-js", "test")
      Skills.create_variation!(skill.id, "react", "test")
    end
  end
end

defmodule SkillSanity.Skills.SkillTest do
  use SkillSanity.DataCase, async: true

  alias SkillSanity.Skills

  describe "valid inputs" do
    test "can create valid skills" do
      Skills.create_skill!("javascript", "JavaScript")
      Skills.create_skill!("react", "React")
      Skills.create_skill!("angular-js", "AngularJS")
    end
  end
end

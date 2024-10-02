defmodule SkillSanity.Skills do
  use Ash.Domain

  alias __MODULE__

  resources do
    resource Skills.Skill do
      define :create_skill, action: :create, args: [:slug, :name]
    end

    resource Skills.Variation do
      define :create_variation, action: :create, args: [:skill_id, :variation]
    end
  end
end

defmodule SkillSanity.Skills.Variation do
  use Ash.Resource,
    domain: SkillSanity.Skills,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key :id

    attribute :variation, :string, allow_nil?: false

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :variation, [:variation]
  end

  relationships do
    belongs_to :skill, SkillSanity.Skills.Skill do
      domain SkillSanity.Skills
      source_attribute :skill_id
      attribute_type :integer
      allow_nil? false
    end
  end

  validations do
    validate string_length(:variation, max: 255)
  end

  actions do
    default_accept [:variation]

    defaults [:read]

    create :create do
      primary? true

      argument :skill_id, :integer, allow_nil?: false

      change manage_relationship(:skill_id, :skill, type: :append)
    end

    read :get_by_variation, get_by: :variation
  end

  code_interface do
    define :get_by_variation, args: [:slug]
    define :create, args: [:skill_id]
  end

  postgres do
    repo SkillSanity.Repo
    table "skill_variations"

    references do
      reference :skill, on_delete: :nothing
    end
  end
end

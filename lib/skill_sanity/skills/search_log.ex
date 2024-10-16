defmodule SkillSanity.Skills.SearchLog do
  use Ash.Resource,
    domain: SkillSanity.Skills,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :search_term, :string, allow_nil?: false
    attribute :confidence, :float

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :matched_skill, SkillSanity.Skills.Skill do
      domain SkillSanity.Skills
      source_attribute :matched_skill_id
      attribute_type :integer
    end

    belongs_to :matched_variation, SkillSanity.Skills.Variation do
      domain SkillSanity.Skills
      source_attribute :matched_variation_id
      attribute_type :integer
    end
  end

  actions do
    defaults [:read]

    create :create do
      accept [
        :search_term,
        :confidence
      ]

      argument :matched_skill_id, :integer
      argument :matched_variation_id, :integer

      change manage_relationship(:matched_skill_id, :matched_skill, type: :append)
      change manage_relationship(:matched_variation_id, :matched_variation, type: :append)
    end
  end

  postgres do
    repo SkillSanity.Repo
    table "search_logs"
  end
end

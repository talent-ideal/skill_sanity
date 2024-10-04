defmodule SkillSanity.Skills.Variation do
  use Ash.Resource,
    domain: SkillSanity.Skills,
    data_layer: AshPostgres.DataLayer

  @similarity_threshold 0.5

  attributes do
    integer_primary_key :id

    attribute :variation, :ci_string, allow_nil?: false

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

  calculations do
    calculate :similarity, :float, expr(trigram_similarity(variation, ^arg(:search_term))) do
      argument :search_term, :string, allow_nil?: false
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

    read :search do
      argument :search_term, :string, allow_nil?: false

      filter expr(trigram_similarity(variation, ^arg(:search_term)) > @similarity_threshold)

      prepare build(sort: [similarity: {%{search_term: arg(:search_term)}, :desc}])
    end
  end

  code_interface do
    define :create, args: [:skill_id]
    define :search, args: [:search_term]
  end

  postgres do
    repo SkillSanity.Repo
    table "skill_variations"

    references do
      reference :skill, on_delete: :nothing
    end
  end
end

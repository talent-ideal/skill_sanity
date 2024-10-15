defmodule SkillSanity.Skills.Skill do
  use Ash.Resource,
    domain: SkillSanity.Skills,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key :id

    attribute :slug, :ci_string, allow_nil?: false
    attribute :name, :ci_string, allow_nil?: false
    attribute :source, :ci_string, allow_nil?: false

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :slug, [:slug]
  end

  validations do
    validate string_length(:slug, max: 255)
    validate match(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/), message: "must be an URL-safe slug"
  end

  actions do
    default_accept [:slug, :name, :source]

    defaults [:create, :read]

    read :get_by_name, get_by: :name
  end

  code_interface do
    define :create
    define :get_by_name, args: [:name]
  end

  postgres do
    repo SkillSanity.Repo
    table "skills"
  end
end

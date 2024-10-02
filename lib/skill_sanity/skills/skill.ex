defmodule SkillSanity.Skills.Skill do
  use Ash.Resource,
    domain: SkillSanity.Skills,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key :id

    attribute :slug, :string, allow_nil?: false
    attribute :name, :string, allow_nil?: false

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
    default_accept [:slug, :name]

    defaults [:create, :read]

    read :get_by_slug, get_by: :slug
  end

  code_interface do
    define :get_by_slug, args: [:slug]
    define :create
  end

  postgres do
    repo SkillSanity.Repo
    table "skills"
  end
end

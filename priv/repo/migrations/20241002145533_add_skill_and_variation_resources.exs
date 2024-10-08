defmodule SkillSanity.Repo.Migrations.AddSkillAndVariationResources do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:skills, primary_key: false) do
      add :id, :bigserial, null: false, primary_key: true
      add :slug, :string, size: 255, null: false
      add :name, :string, size: 255, null: false

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
    end

    create unique_index(:skills, [:slug], name: "skills_slug_index")

    create table(:skill_variations, primary_key: false) do
      add :id, :bigserial, null: false, primary_key: true
      add :variation, :string, size: 255, null: false

      add :inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")

      add :skill_id,
          references(:skills,
            column: :id,
            name: "skill_variations_skill_id_fkey",
            type: :bigint,
            prefix: "public",
            on_delete: :nothing
          ),
          null: false
    end

    create unique_index(:skill_variations, [:variation], name: "skill_variations_variation_index")
  end

  def down do
    drop_if_exists unique_index(:skill_variations, [:variation],
                     name: "skill_variations_variation_index"
                   )

    drop constraint(:skill_variations, "skill_variations_skill_id_fkey")

    drop table(:skill_variations)

    drop_if_exists unique_index(:skills, [:slug], name: "skills_slug_index")

    drop table(:skills)
  end
end

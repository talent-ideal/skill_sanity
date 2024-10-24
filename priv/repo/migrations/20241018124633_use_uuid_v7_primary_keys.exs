defmodule SkillSanity.Repo.Migrations.UseUuidV7PrimaryKeys do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def change do
    # add temp UUID columns

    alter table(:skills) do
      add :uuid_temp, :uuid, default: fragment("uuid_generate_v7()"), null: false
    end

    alter table(:skill_variations) do
      add :uuid_temp, :uuid, default: fragment("uuid_generate_v7()"), null: false
    end

    # add UUID FK column to skill_variations

    alter table(:skill_variations) do
      add :skill_uuid, :uuid
    end

    execute """
    UPDATE skill_variations
    SET skill_uuid = skills.uuid_temp
    FROM skills
    WHERE skill_variations.skill_id = skills.id
    """

    alter table(:skill_variations) do
      modify :skill_uuid, :uuid, null: false
    end

    # add UUID FK columns to search_logs

    alter table(:search_logs) do
      add :matched_skill_uuid, :uuid
      add :matched_variation_uuid, :uuid
    end

    execute """
    UPDATE search_logs
    SET matched_skill_uuid = skills.uuid_temp
    FROM skills
    WHERE search_logs.matched_skill_id = skills.id
    """

    execute """
    UPDATE search_logs
    SET matched_variation_uuid = skill_variations.uuid_temp
    FROM skill_variations
    WHERE search_logs.matched_variation_id = skill_variations.id
    """

    # remove old FK columns

    alter table(:skill_variations) do
      remove :skill_id
    end

    alter table(:search_logs) do
      remove :matched_skill_id
      remove :matched_variation_id
    end

    # drop old PK contraints & columns

    execute "ALTER TABLE skills DROP CONSTRAINT IF EXISTS skills_pkey"
    execute "ALTER TABLE skill_variations DROP CONSTRAINT IF EXISTS skill_variations_pkey"

    alter table(:skills) do
      remove :id
    end

    alter table(:skill_variations) do
      remove :id
    end

    # add new UUID columns PKs

    execute "ALTER TABLE skills ADD PRIMARY KEY (uuid_temp)"
    execute "ALTER TABLE skill_variations ADD PRIMARY KEY (uuid_temp)"

    # create UUID FK contraints

    execute """
    ALTER TABLE skill_variations
    ADD CONSTRAINT skill_variations_skill_uuid_fkey
    FOREIGN KEY (skill_uuid)
    REFERENCES skills(uuid_temp)
    ON DELETE CASCADE
    """

    execute """
    ALTER TABLE search_logs
    ADD CONSTRAINT search_logs_matched_skill_uuid_fkey
    FOREIGN KEY (matched_skill_uuid)
    REFERENCES skills(uuid_temp)
    ON DELETE SET NULL
    """

    execute """
    ALTER TABLE search_logs
    ADD CONSTRAINT search_logs_matched_variation_uuid_fkey
    FOREIGN KEY (matched_variation_uuid)
    REFERENCES skill_variations(uuid_temp)
    ON DELETE SET NULL
    """

    # rename temp UUID columns to id

    execute "ALTER TABLE skills RENAME COLUMN uuid_temp TO id"
    execute "ALTER TABLE skill_variations RENAME COLUMN uuid_temp TO id"

    # rename UUID FK columns to match original column names

    execute "ALTER TABLE skill_variations RENAME COLUMN skill_uuid TO skill_id"

    execute "ALTER TABLE search_logs RENAME COLUMN matched_skill_uuid TO matched_skill_id"
    execute "ALTER TABLE search_logs RENAME COLUMN matched_variation_uuid TO matched_variation_id"

    # drop old FK contraints & rename new ones

    execute "ALTER TABLE skill_variations DROP CONSTRAINT IF EXISTS skill_variations_skill_id_fkey"

    execute "ALTER TABLE skill_variations RENAME CONSTRAINT skill_variations_skill_uuid_fkey TO skill_variations_skill_id_fkey"

    execute "ALTER TABLE search_logs DROP CONSTRAINT IF EXISTS search_logs_matched_skill_id_fkey"

    execute "ALTER TABLE search_logs RENAME CONSTRAINT search_logs_matched_skill_uuid_fkey TO search_logs_matched_skill_id_fkey"

    execute "ALTER TABLE search_logs DROP CONSTRAINT IF EXISTS search_logs_matched_variation_id_fkey"

    execute "ALTER TABLE search_logs RENAME CONSTRAINT search_logs_matched_variation_uuid_fkey TO search_logs_matched_variation_id_fkey"

    # set NOT NULL constraints back

    alter table(:skill_variations) do
      modify :skill_id, :uuid, null: false
    end

    alter table(:search_logs) do
      modify :matched_skill_id, :uuid, null: true
      modify :matched_variation_id, :uuid, null: true
    end

    # update search_logs UUID version (4 -> 7)

    alter table(:search_logs) do
      modify :id, :uuid, default: fragment("uuid_generate_v7()")
    end

    # 19. No sequences to update since we're moving to UUIDs

    # Sequences are not needed for UUIDs; no action required

    # 20. Verify data integrity

    # Cannot be done in migration script; should be tested separately
  end

  # def change do
  #   execute "ALTER TABLE skill_variations DROP CONSTRAINT skill_variations_skill_id_fkey"
  #   execute "ALTER TABLE search_logs DROP CONSTRAINT search_logs_matched_skill_id_fkey"

  #   alter table(:skills) do
  #     remove :id
  #     add :id, :uuid, null: false, primary_key: true, default: fragment("uuid_generate_v7()")
  #   end

  #   execute "ALTER TABLE search_logs DROP CONSTRAINT search_logs_matched_variation_id_fkey"

  #   alter table(:skill_variations) do
  #     remove :skill_id

  #     add :skill_id,
  #         references(:skills,
  #           column: :id,
  #           name: "skill_variations_skill_id_fkey",
  #           type: :uuid,
  #           prefix: "public",
  #           on_delete: :nothing
  #         ),
  #         null: false

  #     remove :id
  #     add :id, :uuid, null: false, primary_key: true, default: fragment("uuid_generate_v7()")
  #   end

  #   alter table(:search_logs) do
  #     remove :matched_skill_id

  #     add :matched_skill_id,
  #         references(:skills,
  #           column: :id,
  #           name: "search_logs_matched_skill_id_fkey",
  #           type: :uuid,
  #           prefix: "public"
  #         ),
  #         null: false

  #     remove :matched_variation_id

  #     add :matched_variation_id,
  #         references(:skill_variations,
  #           column: :id,
  #           name: "search_logs_matched_variation_id_fkey",
  #           type: :uuid,
  #           prefix: "public"
  #         ),
  #         null: false

  #     modify :id, :uuid, default: fragment("uuid_generate_v7()")
  #   end
  # end
end

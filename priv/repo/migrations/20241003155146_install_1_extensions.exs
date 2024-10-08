defmodule SkillSanity.Repo.Migrations.Install1Extensions20241003155144 do
  @moduledoc """
  Installs any extensions that are mentioned in the repo's `installed_extensions/0` callback

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS \"pg_trgm\"")
  end

  def down do
    execute("DROP EXTENSION IF EXISTS \"pg_trgm\"")
  end
end

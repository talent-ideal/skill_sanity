defmodule SkillSanity.Repo do
  use AshPostgres.Repo, otp_app: :skill_sanity

  def installed_extensions do
    ["ash-functions", "uuid-ossp", "citext"]
  end

  def min_pg_version do
    %Version{major: 14, minor: 0, patch: 0}
  end
end

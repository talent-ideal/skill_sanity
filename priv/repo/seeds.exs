# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SkillSanity.Repo.insert!(%SkillSanity.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SkillSanity.Skills

skills_file_path = Path.join([:code.priv_dir(:skill_sanity), "repo", "skills.yml"])

content = File.read!(skills_file_path)
skills_data = YamlElixir.read_from_string!(content)

Enum.each(skills_data, fn skill_entry ->
  slug = skill_entry["skill"]
  name = skill_entry["name"]

  skill = Skills.create_skill!(slug, name)

  variations = skill_entry["variations"] || []

  Enum.each(variations, fn variation ->
    Skills.create_variation!(skill.id, variation)
  end)
end)

alias NimbleCSV.RFC4180, as: CSV

alias SkillSanity.Skills.Skill
alias SkillSanity.Skills.Variation

require Logger
Logger.configure(level: :warning)

skills_file_path =
  Path.join([
    :code.priv_dir(:skill_sanity),
    "../../skill_sanity_notebooks/datasets/output/skills_pylote_2024-10-06.csv"
  ])

csv_content = File.read!(skills_file_path)

dataset = CSV.parse_string(csv_content, skip_headers: true)

source = "pylote_dataset"

skills_data =
  Enum.map(dataset, fn [slug, name, _frequency, _aliases, _id] ->
    %{slug: slug, name: name, source: source}
  end)

unique_skills_data = Enum.uniq_by(skills_data, & &1[:slug])

IO.puts("Upserting #{length(unique_skills_data)} unique skills...")

%{records: inserted_skills, error_count: skills_error_count, errors: skills_errors} =
  Ash.bulk_create(unique_skills_data, Skill, :create,
    return_records?: true,
    upsert?: true,
    upsert_identity: :slug,
    upsert_fields: :slug,
    return_errors?: true,
    select: [:id, :slug]
  )

slug_to_skill_id =
  Enum.reduce(inserted_skills, %{}, fn skill, acc ->
    Map.put(acc, Ash.CiString.value(skill.slug), skill.id)
  end)

variations_data =
  Enum.flat_map(dataset, fn [slug, _name, _frequency, aliases, _id] ->
    skill_id = Map.fetch!(slug_to_skill_id, slug)

    aliases =
      case aliases do
        "" -> []
        _ -> String.split(aliases, ",", trim: true)
      end

    Enum.map(aliases, fn alias ->
      %{skill_id: skill_id, variation: alias, source: source}
    end)
  end)

unique_variations_data = Enum.uniq_by(variations_data, & &1[:variation])

IO.puts("Upserting #{length(unique_variations_data)} unique variations...")

%{records: inserted_variations, error_count: variations_error_count, errors: variations_errors} =
  Ash.bulk_create(unique_variations_data, Variation, :create,
    return_records?: true,
    upsert?: true,
    upsert_identity: :variation,
    upsert_fields: :variation,
    return_errors?: true,
    select: [:id, :variation]
  )

IO.puts("""

===== Final Import Summary =====
Skills in dataset: #{length(skills_data)}
Unique skills in dataset: #{length(unique_skills_data)}
Successfully upserted #{length(inserted_skills)} unique skills.
""")

if skills_error_count > 0 do
  IO.puts("Skills error count: #{skills_error_count}")
  IO.inspect(skills_errors)
end

IO.puts("""
Variations in dataset: #{length(variations_data)}
Unique variations in dataset: #{length(unique_variations_data)}
Successfully upserted #{length(inserted_variations)} unique variations.
""")

if variations_error_count > 0 do
  IO.puts("Variations error count: #{variations_error_count}")
  IO.inspect(variations_errors)
end

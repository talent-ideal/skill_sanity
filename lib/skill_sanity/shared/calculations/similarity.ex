defmodule SkillSanity.Shared.Calculations.Similarity do
  use Ash.Resource.Calculation

  @moduledoc """
  Calculates the trigram similarity of a given attribute based on a search term.

  Usage in resource:

        calculations do
          calculate :similarity,
            :float,
            {SkillSanity.Shared.Calculations.Similarity, attribute: :name} do
              argument :search_term, :string, allow_nil?: false
          end
        end
  """

  @impl true
  def init(opts) do
    if opts[:attribute] do
      {:ok, opts}
    else
      {:error, "The `attribute` option is required."}
    end
  end

  @impl true
  def expression([attribute: attribute], %{arguments: %{search_term: search_term}}) do
    expr(trigram_similarity(^ref(attribute), ^search_term))
  end
end

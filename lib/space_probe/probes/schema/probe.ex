defmodule SpaceProbe.Probes.Schema.Probe do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @fields [:x, :y, :x_limit, :y_limit, :face]

  schema "probes" do
    field :face, :string, default: "R"
    field :x, :integer, default: 0
    field :x_limit, :integer, default: 4
    field :y, :integer, default: 0
    field :y_limit, :integer, default: 4

    timestamps()
  end

  def changeset(%{x_limit: x_limit, y_limit: y_limit} = probe \\ %__MODULE__{}, attrs) do
    probe
    |> cast(attrs, @fields)
    |> validate_number(:x, greater_than_or_equal_to: 0, less_than_or_equal_to: x_limit)
    |> validate_number(:y, greater_than_or_equal_to: 0, less_than_or_equal_to: y_limit)
  end
end

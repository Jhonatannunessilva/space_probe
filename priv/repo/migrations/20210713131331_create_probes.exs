defmodule SpaceProbe.Repo.Migrations.CreateProbes do
  use Ecto.Migration

  def change do
    create table(:probes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :x, :integer
      add :y, :integer
      add :x_limit, :integer
      add :y_limit, :integer
      add :face, :string

      timestamps()
    end

  end
end

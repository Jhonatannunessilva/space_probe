defmodule SpaceProbe.Probes do
  alias SpaceProbe.Repo
  alias SpaceProbe.Probes.Schema.Probe

  def update_probe(changes, probe) do
    probe
    |> Probe.changeset(changes)
    |> Repo.update()
  end

  def get_probe() do
    case Repo.all(Probe) do
      [probe | _] ->
        {:ok, probe}

      _ ->
        {:error, "Probe not found!"}
    end
  end

  def create_probe(params \\ %{}) do
    params |> Probe.changeset() |> Repo.insert()
  end

  def create_probe!(params \\ %{}) do
    params |> Probe.changeset() |> Repo.insert!()
  end
end

defmodule SpaceProbe.Probes do
  alias SpaceProbe.Repo
  alias SpaceProbe.Probes.Schema.Probe

  def execute_instructions(probe, instructions) do
    instructions
    |> Enum.reduce(%{x: probe.x, y: probe.y, face: probe.face}, fn
      "M", acc -> move(acc)
      instruction, acc -> rotate(acc, instruction)
    end)
    |> update_probe(probe)
  end

  defp rotate(%{face: "R"} = changes, "TL"), do: %{changes | face: "U"}
  defp rotate(%{face: "R"} = changes, "TR"), do: %{changes | face: "D"}

  defp rotate(%{face: "U"} = changes, "TL"), do: %{changes | face: "L"}
  defp rotate(%{face: "U"} = changes, "TR"), do: %{changes | face: "R"}

  defp rotate(%{face: "L"} = changes, "TL"), do: %{changes | face: "D"}
  defp rotate(%{face: "L"} = changes, "TR"), do: %{changes | face: "U"}

  defp rotate(%{face: "D"} = changes, "TL"), do: %{changes | face: "R"}
  defp rotate(%{face: "D"} = changes, "TR"), do: %{changes | face: "L"}
  defp rotate(changes, _direction), do: changes

  defp move(%{face: "R", x: x} = changes), do: %{changes | x: x + 1}
  defp move(%{face: "U", y: y} = changes), do: %{changes | y: y + 1}
  defp move(%{face: "L", x: x} = changes), do: %{changes | x: x - 1}
  defp move(%{face: "D", y: y} = changes), do: %{changes | y: y - 1}
  defp move(changes), do: changes

  def reset_position(probe) do
    update_probe(%{x: 0, y: 0, face: "R"}, probe)
  end

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
        {:error, :not_found}
    end
  end

  def create_probe(params \\ %{}) do
    params |> Probe.changeset() |> Repo.insert()
  end

  def create_probe!(params \\ %{}) do
    params |> Probe.changeset() |> Repo.insert!()
  end
end

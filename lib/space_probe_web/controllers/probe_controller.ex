defmodule SpaceProbeWeb.ProbeController do
  use SpaceProbeWeb, :controller

  alias SpaceProbe.Probes

  action_fallback SpaceProbeWeb.FallbackController

  def show(conn, _params) do
    with {:ok, probe} <- Probes.get_probe() do
      conn
      |> put_status(:ok)
      |> render("show.json", probe: probe)
    end
  end

  def execute_instructions(conn, %{"instructions" => instructions}) do
    with {:ok, probe} <- Probes.get_probe(),
         {:ok, probe} <- Probes.execute_instructions(probe, instructions) do
      conn
      |> put_status(:ok)
      |> render("show_coordinates.json", probe: probe)
    end
  end

  def reset_position(conn, _params) do
    with {:ok, probe} <- Probes.get_probe(),
         {:ok, _} <- Probes.reset_position(probe) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end

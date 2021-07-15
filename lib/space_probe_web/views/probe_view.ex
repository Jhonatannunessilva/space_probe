defmodule SpaceProbeWeb.ProbeView do
  use SpaceProbeWeb, :view
  alias SpaceProbeWeb.ProbeView

  def render("show.json", %{probe: probe}) do
    render_one(probe, ProbeView, "probe.json")
  end

  def render("show_coordinates.json", %{probe: %{x: x, y: y}}) do
    %{x: x, y: y}
  end

  def render("probe.json", %{probe: probe}) do
    %{
      x: probe.x,
      y: probe.y,
      face: probe.face
    }
  end
end

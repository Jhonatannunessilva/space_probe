defmodule SpaceProbeWeb.FallbackController do
  use SpaceProbeWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(SpaceProbeWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(SpaceProbeWeb.ErrorView)
    |> render("404.json")
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(:internal_server_error)
    |> put_view(SpaceProbeWeb.ErrorView)
    |> render("500.json")
  end
end

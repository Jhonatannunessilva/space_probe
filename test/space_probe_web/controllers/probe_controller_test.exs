defmodule SpaceProbeWeb.ProbeControllerTest do
  use SpaceProbeWeb.ConnCase, async: true

  alias SpaceProbe.Probes

  def fixture(:probe) do
    {:ok, probe} = Probes.create_probe()
    probe
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show probe" do
    test "when the probe exists, returns the coordinates and the face", %{conn: conn} do
      _probe = fixture(:probe)

      expected_response = %{"face" => "R", "x" => 0, "y" => 0}

      conn = get(conn, Routes.probe_path(conn, :show))
      response = json_response(conn, 200)

      assert response == expected_response
    end

    test "when the probe does not exist, it returns an error saying not found", %{conn: conn} do
      expected_response = %{"detail" => "Not Found"}

      conn = get(conn, Routes.probe_path(conn, :show))

      response = json_response(conn, 404)["errors"]

      assert response == expected_response
    end
  end

  describe "execute instructions" do
    setup [:create_probe]

    test "when a list of valid instructions is given, it returns the probe coordinates at the new position",
         %{conn: conn} do
      instructions = %{instructions: ["TL", "M", "M", "M", "TR", "M", "M"]}

      expected_response = %{"x" => 2, "y" => 3}

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 200)

      assert response == expected_response
    end

    test "when a list of instructions is received and it causes the value of X to be less than 0, an error is returned saying that X must be greater than or equal to 0",
         %{conn: conn} do
      instructions = %{instructions: ["TL", "TL", "M"]}

      expected_response = %{"x" => ["must be greater than or equal to 0"]}

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 422)["errors"]

      assert response == expected_response
    end

    test "when a list of instructions is received and it causes the value of X to be greater than X_LIMIT, an error is returned saying that X must be less than or equal to X_LIMIT",
         %{conn: conn} do
      instructions = %{instructions: ["M", "M", "M", "M", "M"]}

      expected_response = %{"x" => ["must be less than or equal to 4"]}

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 422)["errors"]

      assert response == expected_response
    end

    test "when a list of instructions is received and it causes the value of Y to be less than 0, an error is returned saying that Y must be greater than or equal to 0",
         %{conn: conn} do
      instructions = %{instructions: ["TR", "M"]}

      expected_response = %{"y" => ["must be greater than or equal to 0"]}

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 422)["errors"]

      assert response == expected_response
    end

    test "when a list of instructions is received and it causes the value of Y to be greater than Y_LIMIT, an error is returned saying that Y must be less than or equal to Y_LIMIT",
         %{conn: conn} do
      instructions = %{instructions: ["TL", "M", "M", "M", "M", "M"]}

      expected_response = %{"y" => ["must be less than or equal to 4"]}

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 422)["errors"]

      assert response == expected_response
    end

    test "when a list of instructions is received and it causes the value of X and Y to be less than 0, an error is returned saying that X and Y must be greater than or equal to 0",
         %{conn: conn} do
      instructions = %{instructions: ["TR", "M", "TR", "M"]}

      expected_response = %{
        "x" => ["must be greater than or equal to 0"],
        "y" => ["must be greater than or equal to 0"]
      }

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 422)["errors"]

      assert response == expected_response
    end

    test "when a list of instructions is received and it causes the value of X and Y to be greater than X_LIMIT and Y_LIMIT, an error is returned saying that X and Y must be less than or equal to X_LIMIT and Y_LIMIT",
         %{conn: conn} do
      instructions = %{instructions: ["TL", "M", "M", "M", "M", "M", "TR", "M", "M", "M", "M", "M"]}

      expected_response = %{
        "x" => ["must be less than or equal to 4"],
        "y" => ["must be less than or equal to 4"]
      }

      conn = post(conn, Routes.probe_path(conn, :execute_instructions, instructions))

      response = json_response(conn, 422)["errors"]

      assert response == expected_response
    end
  end

  describe "reset probe position" do
    setup [:create_probe]

    test "when this controller is called, reset the probe position", %{conn: conn} do
      conn = post(conn, Routes.probe_path(conn, :reset_position))

      assert response(conn, 204)
    end
  end

  defp create_probe(_) do
    probe = fixture(:probe)
    %{probe: probe}
  end
end

defmodule SpaceProbe.ProbesTest do
  use SpaceProbe.DataCase, async: true

  alias SpaceProbe.Probes

  setup [:create_probe]

  describe "execute_instructions/2" do
    test "when a list of valid instructions is received, it returns the probe at the new position",
         %{probe: probe} do
      instructions = ["TL", "M", "M", "M", "TR", "M", "M"]

      {:ok, updated_probe} = Probes.execute_instructions(probe, instructions)

      assert %{x: 2, y: 3} = updated_probe
    end

    test "when a list of instructions is received and it causes the value of X to be less than 0, an error is returned saying that X must be greater than or equal to 0",
         %{probe: probe} do
      instructions = ["TL", "TL", "M"]

      expected_response = %{x: ["must be greater than or equal to 0"]}

      {:error, changeset} = Probes.execute_instructions(probe, instructions)

      assert errors_on(changeset) == expected_response
    end

    test "when a list of instructions is received and it causes the value of X to be greater than X_LIMIT, an error is returned saying that X must be less than or equal to X_LIMIT",
         %{probe: %{x_limit: x_limit} = probe} do
      instructions = ["M", "M", "M", "M", "M"]

      expected_response = %{x: ["must be less than or equal to #{x_limit}"]}

      {:error, changeset} = Probes.execute_instructions(probe, instructions)

      assert errors_on(changeset) == expected_response
    end

    test "when a list of instructions is received and it causes the value of Y to be less than 0, an error is returned saying that Y must be greater than or equal to 0",
         %{probe: probe} do
      instructions = ["TR", "M"]

      expected_response = %{y: ["must be greater than or equal to 0"]}

      {:error, changeset} = Probes.execute_instructions(probe, instructions)

      assert errors_on(changeset) == expected_response
    end

    test "when a list of instructions is received and it causes the value of Y to be greater than Y_LIMIT, an error is returned saying that Y must be less than or equal to Y_LIMIT",
         %{probe: %{y_limit: y_limit} = probe} do
      instructions = ["TL", "M", "M", "M", "M", "M"]

      expected_response = %{y: ["must be less than or equal to #{y_limit}"]}

      {:error, changeset} = Probes.execute_instructions(probe, instructions)

      assert errors_on(changeset) == expected_response
    end

    test "when a list of instructions is received and it causes the value of X and Y to be less than 0, an error is returned saying that X and Y must be greater than or equal to 0",
         %{probe: probe} do
      instructions = ["TR", "M", "TR", "M"]

      expected_response = %{
        x: ["must be greater than or equal to 0"],
        y: ["must be greater than or equal to 0"]
      }

      {:error, changeset} = Probes.execute_instructions(probe, instructions)

      assert errors_on(changeset) == expected_response
    end

    test "when a list of instructions is received and it causes the value of X and Y to be greater than X_LIMIT and Y_LIMIT, an error is returned saying that X and Y must be less than or equal to X_LIMIT and Y_LIMIT",
         %{probe: %{x_limit: x_limit, y_limit: y_limit} = probe} do
      instructions = ["TL", "M", "M", "M", "M", "M", "TR", "M", "M", "M", "M", "M"]

      expected_response = %{
        x: ["must be less than or equal to #{x_limit}"],
        y: ["must be less than or equal to #{y_limit}"]
      }

      {:error, changeset} = Probes.execute_instructions(probe, instructions)

      assert errors_on(changeset) == expected_response
    end
  end

  describe "reset_position/1" do
    test "when a probe is given, returns a probe with the X, Y and FACE values ​​reset", %{
      probe: probe
    } do
      {:ok, updated_probe} = Probes.reset_position(probe)

      assert %{x: 0, y: 0, face: "R"} = updated_probe
    end
  end

  defp create_probe(_) do
    {:ok, probe} = Probes.create_probe()
    %{probe: probe}
  end
end

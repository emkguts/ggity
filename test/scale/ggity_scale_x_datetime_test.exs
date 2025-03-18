defmodule GGityScaleXDateTimeTest do
  use ExUnit.Case, async: true

  alias GGity.Scale.X

  describe "train/2" do
    test "creates a correct transformation function for NaiveDateTime values" do
      values = [
        ~N[2001-01-01 00:00:00],
        ~N[2001-01-03 00:00:00],
        ~N[2001-01-05 00:00:00]
      ]

      [date1, date2, date3] = values
      scale = X.DateTime.train(X.DateTime.new(), {date1, date3})
      assert scale.transform.(date1) == 0
      assert scale.transform.(date2) == 100
      assert scale.transform.(date3) == 200
    end

    test "creates a correct transformation function for DateTime values" do
      values = [
        ~U[2001-01-01 00:00:00Z],
        ~U[2001-01-03 00:00:00Z],
        ~U[2001-01-05 00:00:00Z]
      ]

      [date1, date2, date3] = values
      scale = X.DateTime.train(X.DateTime.new(), {date1, date3})
      assert scale.transform.(date1) == 0
      assert scale.transform.(date2) == 100
      assert scale.transform.(date3) == 200
    end

    test "raises with non-date time values" do
      # Use function to create values to avoid static type checking, which was producing warnings
      invalid_min_max = fn -> {1, 4} end

      assert_raise FunctionClauseError, fn ->
        X.DateTime.train(X.DateTime.new(), invalid_min_max.())
      end
    end
  end
end

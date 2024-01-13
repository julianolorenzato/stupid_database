defmodule StupidDatabaseTest do
  use ExUnit.Case
  doctest StupidDatabase

  import StupidDatabase

  @data %{
    "employees" => [
      %{id: 1, name: "Marlon", department: "Tech"},
      %{id: 2, name: "Mary", department: "Finance"},
      %{id: 3, name: "Sarah", department: "Tech"},
      %{id: 4, name: "Jason", department: "Marketing"},
      %{id: 5, name: "Ada", department: "Marketing"}
    ],
    "courses" => [
      %{subject: "cook", hours: 160},
      %{subject: "math", hours: 70},
      %{subject: "astronomy", hours: 70},
      %{subject: "programming", hours: 110}
    ],
    "fruits" => [
      %{name: "banana", color: <<255, 255, 53>>, seeds: false},
      %{name: "grape", color: <<111, 45, 168>>, seeds: true},
      %{name: "strawberry", color: <<200, 63, 73>>, seeds: true},
      %{name: "blueberry", color: <<79, 134, 247>>, seeds: false},
      %{name: "orange", color: <<255, 131, 0>>, seeds: true}
    ]
  }

  test "from" do
    got = from(@data, "fruits")

    expect = @data["fruits"]

    assert from(@data, "fruits") == @data["fruits"]
  end

  test "select" do
    got = select(@data["fruits"], [:color, :seeds])

    expected = [
      %{color: <<255, 255, 53>>, seeds: false},
      %{color: <<111, 45, 168>>, seeds: true},
      %{color: <<200, 63, 73>>, seeds: true},
      %{color: <<79, 134, 247>>, seeds: false},
      %{color: <<255, 131, 0>>, seeds: true}
    ]

    assert got == expected
  end

  describe "where" do
    test "equal to" do
      got = where(@data["fruits"], seeds: [eq: true])

      expected = [
        %{name: "grape", color: <<111, 45, 168>>, seeds: true},
        %{name: "strawberry", color: <<200, 63, 73>>, seeds: true},
        %{name: "orange", color: <<255, 131, 0>>, seeds: true}
      ]

      assert got == expected
    end

    test "greater than" do
      got = where(@data["courses"], hours: [gt: 70])

      expected = [
        %{subject: "cook", hours: 160},
        %{subject: "programming", hours: 110}
      ]

      assert got == expected
    end

    test "greather than or equal to" do
      got = where(@data["courses"], hours: [gte: 70])

      expected = [
        %{subject: "cook", hours: 160},
        %{subject: "math", hours: 70},
        %{subject: "astronomy", hours: 70},
        %{subject: "programming", hours: 110}
      ]

      assert got == expected
    end

    test "less than" do
      got = where(@data["courses"], hours: [lt: 110])

      expected = [
        %{subject: "math", hours: 70},
        %{subject: "astronomy", hours: 70}
      ]

      assert got == expected
    end

    test "less than or equal to" do
      got = where(@data["courses"], hours: [lte: 110])

      expected = [
        %{subject: "math", hours: 70},
        %{subject: "astronomy", hours: 70},
        %{subject: "programming", hours: 110}
      ]

      assert got == expected
    end

    test "contains" do
      got = where(@data["fruits"], name: [ctns: "berry"])

      expected = [
        %{name: "strawberry", color: <<200, 63, 73>>, seeds: true},
        %{name: "blueberry", color: <<79, 134, 247>>, seeds: false}
      ]

      assert got == expected
    end

    test "starts with" do
      got = where(@data["fruits"], color: [sw: <<255>>])

      expected = [
        %{name: "banana", color: <<255, 255, 53>>, seeds: false},
        %{name: "orange", color: <<255, 131, 0>>, seeds: true}
      ]

      assert got == expected
    end
  end

  describe "order by" do
    test "ascending" do
      got = order_by(@data["courses"], :hours, :asc)

      expected = [
        %{subject: "astronomy", hours: 70},
        %{subject: "math", hours: 70},
        %{subject: "programming", hours: 110},
        %{subject: "cook", hours: 160}
      ]

      assert got == expected
    end

    test "descending" do
      got = order_by(@data["courses"], :hours, :desc)

      expected = [
        %{subject: "cook", hours: 160},
        %{subject: "programming", hours: 110},
        %{subject: "astronomy", hours: 70},
        %{subject: "math", hours: 70}
      ]

      assert got == expected
    end
  end

  describe "group by" do
    test "count" do
      got = group_by(@data["employees"], :department, :count)

      expect = [
        %{department: "Finance", count: 1},
        %{department: "Marketing", count: 2},
        %{department: "Tech", count: 2}
      ]

      assert got == expect
    end

    test "sum" do
      got = group_by(@data["courses"], :hours, :sum)


      IO.inspect(got)
    end
  end

  # test "count" do
  #   got = count(@data["fruits"])

  #   expected = 5

  #   assert got == expected
  # end

  describe "chaining statements" do
    test "select from" do
      got =
        @data
        |> from("fruits")
        |> select([:name, :seeds])

      expected = [
        %{name: "banana", seeds: false},
        %{name: "grape", seeds: true},
        %{name: "strawberry", seeds: true},
        %{name: "blueberry", seeds: false},
        %{name: "orange", seeds: true}
      ]

      assert got == expected
    end

    test "select from where" do
      got =
        @data
        |> from("fruits")
        |> select([:name, :color])
        |> where(name: [ctns: "berry"])

      expected = [
        %{name: "strawberry", color: <<200, 63, 73>>},
        %{name: "blueberry", color: <<79, 134, 247>>}
      ]

      assert got == expected
    end

    test "select from order by" do
      got =
        @data
        |> from("courses")
        |> select([:subject])
        |> order_by(:subject, :asc)

      expected = [
        %{subject: "astronomy"},
        %{subject: "cook"},
        %{subject: "math"},
        %{subject: "programming"}
      ]

      assert got == expected
    end
  end
end

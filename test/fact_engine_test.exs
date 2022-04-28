defmodule FactEngineTest do
  use ExUnit.Case
  doctest FactEngine

  test "greets the world" do
    assert FactEngine.hello() == :world
  end
end

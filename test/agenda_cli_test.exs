defmodule AgendaCliTest do
  use ExUnit.Case
  doctest AgendaCli

  test "greets the world" do
    assert AgendaCli.hello() == :world
  end
end

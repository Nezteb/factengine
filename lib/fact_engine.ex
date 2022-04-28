defmodule FactEngine do
  @moduledoc """
  Documentation for `FactEngine`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> FactEngine.hello()
      :world

  """
  def read_example_files do
    Path.wildcard("./examples/**/in.txt")
    |> Enum.map(fn file ->
      {:ok, content} = File.read(file)

      content
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line ->
        case FactEngine.Parser.fact(line) do
          {:ok, results, _, _, _, _} -> 
            FactEngine.Utils.combine_tuple_list(results)
          {:error, message, string, _, _, _} -> "#{message}: #{string}"
        end
      end)
    end)
  end
end

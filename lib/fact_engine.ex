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
      # Parse each file
      |> Enum.map(fn line ->
        case FactEngine.Parser.fact(line) do
          {:ok, results, _, _, _, _} ->
            {:ok, FactEngine.Utils.combine_tuple_list(results)}

          {:error, message, string, _, _, _} ->
            IO.inspect("#{file}: #{message}: #{string}")
        end
      end)
      # Discard any invalid lines
      |> Enum.filter(fn tuple ->
        case tuple do
          {:ok, _} -> true
          _ -> false
        end
      end)
      # Extract the results
      |> Enum.map(fn ok_tuple ->
        {:ok, results} = ok_tuple
        results
      end)
      |> Enum.reduce(%{}, fn line, logic_table ->
        IO.inspect(line, label: "Line")

        result = case line do
          %{command: :input, property: query_property, subject: subjects} ->
            # TODO: Make this a function to clean it up
            {_, new_map} = FactEngine.Utils.add_item_to_map(logic_table, query_property, subjects)
            new_map

          %{
            command: :query,
            property: query_property,
            subject: query_subjects,
            variable: query_variables
          } ->
            # TODO: Account for subjects and variables in queries...
            logic_table

          %{command: :query, property: query_property, subject: query_subjects} ->
            # returns list of lists
            subjects = Map.get(logic_table, query_property)

            Enum.map(subjects, fn subject ->
              IO.inspect({query_subjects, subject}, label: "Query, actual")
              is_subset = MapSet.subset?(MapSet.new([query_subjects]), MapSet.new(subject))
              IO.puts("#{is_subset}")
            end)

            logic_table

          %{command: :query, property: query_property, variable: query_variables} ->
            subjects = Map.get(logic_table, query_property)

            # TODO: How to handle multiple query variables?
            query_result =
              case subjects do
                nil ->
                  false

                _ ->
                  Enum.map(subjects, fn subject ->
                    [string_subject] = subject
                    IO.puts("#{query_variables}: #{string_subject}")
                    # IO.inspect({query_variables, subject}, label: "Query, actual")
                    

                    # is_subset = MapSet.subset?(MapSet.new([query_subjects]), MapSet.new(subject))
                    # IO.puts("#{is_subset}")
                  end)
              end

            IO.inspect(query_result, label: "Query result")
            logic_table
        end

        IO.puts("")
        result
      end)
    end)

    # nil
  end
end

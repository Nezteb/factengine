defmodule FactEngine.Utils do
  import NimbleParsec
  
  def combine_tuple_list(list) do
    Enum.reduce(list, %{}, fn tuple, map ->
      {key, value} = tuple
    
      {_, new_map} = Map.get_and_update(map, key, fn current ->
        case current do
          nil ->
            {key, value}
          currentList when is_list(currentList) ->
            {key, [value | currentList]}
          currentString when is_binary(currentString) ->
            {key, [currentString, value]}
        end
      end)
    
      new_map
    end)
  end
  
  def any_string do
    ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_], min: 1)
  end

  def word_that_starts_with_lowercase_string do
    ascii_string([?a..?z, ?0..?9], min: 1)
    |> concat(optional(any_string()))
    |> reduce({Enum, :join, []}) # Reduce the matches into one large string
    |> label("Any string that starts with a lowercase letter")
  end

  def word_that_starts_with_uppercase_string do
    ascii_string([?A..?Z], min: 1)
    |> concat(optional(any_string()))
    |> reduce({Enum, :join, []}) # Reduce the matches into one large string
    |> label("Any string that starts with a uppercase letter")
  end
end

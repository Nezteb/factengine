defmodule FactEngine.Utils do
  import NimbleParsec
  
  # If item is a string, prepends it to the list
  # If item is a list, combine the two lists
  def add_item_to_map(map, key, item) do
    Map.get_and_update(map, key, fn current ->
      # TODO: There must be a better way to do this (maybe with a `with`?)
      case current do
        nil when is_binary(item) ->
          {key, [[item]]}
        nil when is_list(item) ->
          {key, [item]}
        _ when is_binary(item) ->
          {key, [[item] | current]}
        _ when is_list(item) ->
          {key, [item | current]}
      end
    end)
  end
  
  # Turns a list of tuples like {:atom, "string"} and turns them into a map,
  # combining similarly keyed strings into lists
  def combine_tuple_list(list) do
    Enum.reduce(list, %{}, fn tuple, map ->
      {key, value} = tuple
    
      # This will update a key whether the incoming value is a single string or a list
      {_, new_map} = Map.get_and_update(map, key, fn current ->
        case current do
          nil ->
            {key, value}
          _ when is_binary(current) ->
            {key, [current, value]}
          _ when is_list(current) ->
            {key, [value | current]}
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

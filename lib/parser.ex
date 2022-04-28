defmodule FactEngine.Parser do
  @moduledoc """
  The FactEngine fact parser is based on the description of the grammar in README.pdf
  """
  import NimbleParsec
  import FactEngine.Utils

  # Commands are one of two values, and there is only ever one of them
  command =
    choice([
      string("INPUT") |> replace(:input),
      string("QUERY") |> replace(:query)
    ])
    |> unwrap_and_tag(:command)
    |> label("Either the term INPUT or the term QUERY")

  # Properties are only lowercase strings, and there is only ever one of them
  property_string =
    word_that_starts_with_lowercase_string()
    |> unwrap_and_tag(:property)

  # In this context a "target" is something a property is known to apply to
  target_string =
    word_that_starts_with_lowercase_string()
    |> unwrap_and_tag(:subject)
  
  # In this context a "variable" for which we don't know any properties that apply
  variable_string =
    word_that_starts_with_uppercase_string()
    |> unwrap_and_tag(:variable)
  
  subject =
    choice([target_string, variable_string])
    |> label("Either a target or a subject")

  first_subject =
    subject
    |> label("First subject before the comma")

  next_subjects =
    ignore(string(", "))
    |> concat(subject)
    |> label("Additional comma separated subjects after the first")

  subjects =
    ignore(string("("))
    |> concat(first_subject)
    |> times(next_subjects, min: 0)
    |> ignore(string(")"))
    |> label("A comma separated list of subjects surrounded by parentheses")

  fact =
    command
    |> ignore(string(" "))
    |> concat(property_string)
    |> ignore(string(" "))
    |> concat(subjects)
    |> ignore(eos())

  defparsec(:fact, fact, debug: false, export_metadata: true)
end

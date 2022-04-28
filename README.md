# FactEngine

## Initial Brainstorm

Steps:
1. Build a parser to read each `in.txt` file and output a tokenized list.
   1. NimbleParsec would be good for this.
   2. Our grammar consists of:
      1. command: a single string that is either `INPUT` or `QUERY`
      2. property: a single string that starts with a lowercase letter
      3. subjects: a list of one or more strings (in a comma separated list) in one of two forms, all of which is wrapped in parentheses
         1. target: a known string subject whose properties are known
         2. variable: a subject whose properties we don't know (variables are only present in `QUERY` commands)
2. Build up a dynamic logic table from the `INPUT` commands (an adjacency list maybe?).
   1. Each property is a key whose value is a list of each subject for which that property applies
      1. ```
         %{
           "are_friends" -> [["alex", "sam"], ["frog", "toad"]]
         }
         ```
      2. ```
         %{
            "is_a_cat" -> ["lucy", "garfield", "bowler_cat"]
            "loves" -> ["garfield", "lasagna"]
         }
         ```
      3. ```
         %{
            "make_a_triple" -> [["5", "3", "4"], ["13", "5", "12"]]
         }
         ```
3. Implement the `QUERY` commands that will query the logic table.
   1. Check which subjects we know have this property (following examples assume the adjacency lists above)
      1. `QUERY are_friends (X, sam)` would check the `"are_friends"` key for any sublist containing `"sam"` and return all *other* list entries.
      2. `QUERY is_a_cat (X)` would check `"is_a_cat"` and return everything in the list. `QUERY loves (garfield, FavoriteFood)` would check `"loves"` for any sublist containing `"garfield"` and return all *other* list entries.
      3. `QUERY make_a_triple (X, 4, Y)` would check `"make_a_triple"` for any sublist that contains `"4"` and return the rest of the elements if equal to the number of variables. `QUERY make_a_triple (X, X, Y)` would check `"make_a_triple"` and look for any list that has two variables of the same value (and in this case find none, thus returning false).
4. Build a module that will test the logic engine's output against the `out.txt` files.

Steps 1 and 4 seem trivial. Steps 2 and 3 are going to be the real meat and potatos.

## Running

```zsh
> cd /path/to/factengine
> iex -S mix
iex(1)> FactEngine.run
<output>
```

defmodule HtmlDecoder.IExAwareOptimisticDecoderWithBinaryPart do
  def none_is_ampersand([var]) do
    quote do
      unquote(var) != ?&
    end
  end

  def none_is_ampersand([var | vars]) do
    right_hand_side = none_is_ampersand(vars)

    quote do
      unquote(var) != ?& and unquote(right_hand_side)
    end
  end

  defmacro define_happy_path_to_iodata(kind, name, fallback, amount, opts \\ []) when kind in [:def, :defp] and is_atom(name) and is_atom(fallback) do
    debug? = Keyword.get(opts, :debug?, false)

    vars = Macro.generate_arguments(amount, __MODULE__)
    pattern = none_is_ampersand(vars)
    bytes =
      quote do
        << unquote_splicing(vars) >>
      end

    ast =
      case kind do
        :def ->
          quote do
            def unquote(name)(unquote(bytes) <> rest = input) when unquote(pattern) do
              [binary_part(input, 0, unquote(amount)) | unquote(name)(rest)]
            end

            def unquote(name)(rest) do
              unquote(fallback)(rest)
            end
          end

        :defp ->
          quote do
            defp unquote(name)(unquote(bytes) <> rest = input) when unquote(pattern) do
              [binary_part(input, 0, unquote(amount)) | unquote(name)(rest)]
            end

            defp unquote(name)(rest) do
              unquote(fallback)(rest)
            end
          end
      end


    if debug? do
      ast
      |> Macro.to_string()
      |> Code.format_string!
      |> IO.puts
    end

    ast
  end

  defmacro defdecoder(name, opts) do
    steps = Keyword.fetch!(opts, :steps)
    [first_step | _rest] = all_steps = steps ++ [1]

    left = List.delete_at(all_steps, -1)
    right = List.delete_at(all_steps, 0)

    happy_paths =
      for {left_step, right_step} <- List.zip([left, right]) do
        atom_left = String.to_atom("to_iodata#{left_step}")
        atom_right = String.to_atom("to_iodata#{right_step}")

        quote do
          define_happy_path_to_iodata(
            :defp,
            unquote(atom_left),
            unquote(atom_right),
            unquote(left_step)
          )
        end
      end

    entities = [{"&amp;", ?&}, {"&lt;", ?>}, {"&gt;", ?>}, {"&quot;", ?"}, {"&#39;", ?'}]

    first_happy_path = String.to_atom("to_iodata#{first_step}")

    clauses =
      for {encoded, decoded} <- entities do
        quote do
          defp to_iodata1(unquote(encoded) <> rest) do
            [unquote(decoded) | unquote(first_happy_path)(rest)]
          end
        end
      end

    quote do
      defmodule unquote(name) do
        import HtmlDecoder.IExAwareOptimisticDecoderWithBinaryPart

        unquote_splicing(clauses)

        defp to_iodata1(<< c, rest :: binary >>) do
          [c | to_iodata1(rest)]
        end

        defp to_iodata1(<<>>) do
          []
        end

        defp to_iodata0("iex&gt;" <> rest) do
          ["iex>" | unquote(first_happy_path)(rest)]
        end

        defp to_iodata0(input) do
          unquote(first_happy_path)(input)
        end

        unquote_splicing(happy_paths)

        def unescape_html_entities(html) do
          html
          |> to_iodata0()
          |> IO.iodata_to_binary
        end
      end
    end
  end
end
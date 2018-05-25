defmodule HtmlDecoder.OptimisticDecoderWithoutBinaryPart do
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
              [unquote(bytes) | unquote(name)(rest)]
            end

            def unquote(name)(rest) do
              unquote(fallback)(rest)
            end
          end

        :defp ->
          quote do
            defp unquote(name)(unquote(bytes) <> rest = input) when unquote(pattern) do
              [unquote(bytes) | unquote(name)(rest)]
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
end
defmodule HtmlDecoder.Benchmark.Main do
  alias HtmlDecoder.Encoder

  alias HtmlDecoder.Decoders.{
    # Calls String.replace multiple times
    StringReplace,
    # Tests one byte at a time
    Simple,
    # Binary Part
    BP_8,
    BP_16,
    BP_32,
    BP_64,
    BP_16_8,
    BP_30_10,
    BP_32_16,
    BP_36_12,
    BP_32_16_8,
    BP_36_12_4,
    BP_64_16,
    BP_64_32,
    BP_64_32_16_8,
    BP_27_9_3,
    BP_42_14_5,
    # Charlist
    CL_8,
    CL_16,
    CL_32,
    CL_16_8,
    CL_32_16,
    CL_32_16_8,
    # IEx aware
    IEx_32,
    IEx_36_12,
    IEx_12_4
  }

  def extract_code_from_html_file(file) do
    lists =
      Regex.scan(~r/<pre><code(?:\s+class="(iex elixir|elixir)")?>([^<]*)<\/code><\/pre>/, file)

    for [_binary, _language, contents] <- lists do
      contents
    end
  end

  def extract_code_from_docs() do
    Path.wildcard("benchmarks/inputs/**/doc/*.html")
    |> Enum.map(&File.read!/1)
    |> Enum.map(&extract_code_from_html_file/1)
    |> List.flatten()
  end

  def run() do
    # Gather data for the benchmark
    raw_inputs = extract_code_from_docs()
    escaped_inputs = Enum.map(raw_inputs, &Encoder.html_escape/1)
    # Run the benchmark
    Benchee.run(
      %{
        # The most "important" decoders
        "String Replace" => fn ->
          Enum.map(escaped_inputs, &StringReplace.unescape_html_entities/1)
        end,
        "Simple" => fn ->
          Enum.map(escaped_inputs, &Simple.unescape_html_entities/1)
        end,
        "Binary Part (36 + 12)" => fn ->
          Enum.map(escaped_inputs, &BP_36_12.unescape_html_entities/1)
        end,
        # IEx aware decoders
        "IEx Aware (32)" => fn ->
          Enum.map(escaped_inputs, &IEx_32.unescape_html_entities/1)
        end,
        "IEx Aware (36 + 12)" => fn ->
          Enum.map(escaped_inputs, &IEx_36_12.unescape_html_entities/1)
        end,
        "IEx Aware (12 + 4)" => fn ->
          Enum.map(escaped_inputs, &IEx_12_4.unescape_html_entities/1)
        end,
        # Other attempts:
        #  - Binaries
        "Binary Part (8)" => fn ->
          Enum.map(escaped_inputs, &BP_8.unescape_html_entities/1)
        end,
        "Binary Part (16)" => fn ->
          Enum.map(escaped_inputs, &BP_16.unescape_html_entities/1)
        end,
        "Binary Part (32)" => fn ->
          Enum.map(escaped_inputs, &BP_32.unescape_html_entities/1)
        end,
        "Binary Part (64)" => fn ->
          Enum.map(escaped_inputs, &BP_64.unescape_html_entities/1)
        end,
        "Binary Part (16 + 8)" => fn ->
          Enum.map(escaped_inputs, &BP_16_8.unescape_html_entities/1)
        end,
        "Binary Part (30 + 10)" => fn ->
          Enum.map(escaped_inputs, &BP_30_10.unescape_html_entities/1)
        end,
        "Binary Part (32 + 16)" => fn ->
          Enum.map(escaped_inputs, &BP_32_16.unescape_html_entities/1)
        end,
        "Binary Part (27 + 9 + 3)" => fn ->
          Enum.map(escaped_inputs, &BP_27_9_3.unescape_html_entities/1)
        end,
        "Binary Part (42 + 14 + 5)" => fn ->
          Enum.map(escaped_inputs, &BP_42_14_5.unescape_html_entities/1)
        end,
        "Binary Part (64 + 32)" => fn ->
          Enum.map(escaped_inputs, &BP_64_32.unescape_html_entities/1)
        end,
        "Binary Part (64 + 16)" => fn ->
          Enum.map(escaped_inputs, &BP_64_16.unescape_html_entities/1)
        end,
        "Binary Part (32 + 16 + 8)" => fn ->
          Enum.map(escaped_inputs, &BP_32_16_8.unescape_html_entities/1)
        end,
        "Binary Part (36 + 12 + 4)" => fn ->
          Enum.map(escaped_inputs, &BP_36_12_4.unescape_html_entities/1)
        end,
        "Binary Part (64 + 32 + 16 + 8)" => fn ->
          Enum.map(escaped_inputs, &BP_64_32_16_8.unescape_html_entities/1)
        end,
        #  - Charlists
        "Charlist (8)" => fn ->
          Enum.map(escaped_inputs, &CL_8.unescape_html_entities/1)
        end,
        "Charlist (16)" => fn ->
          Enum.map(escaped_inputs, &CL_16.unescape_html_entities/1)
        end,
        "Charlist (32)" => fn ->
          Enum.map(escaped_inputs, &CL_32.unescape_html_entities/1)
        end,
        "Charlist (16 + 8)" => fn ->
          Enum.map(escaped_inputs, &CL_16_8.unescape_html_entities/1)
        end,
        "Charlist (32 + 16)" => fn ->
          Enum.map(escaped_inputs, &CL_32_16.unescape_html_entities/1)
        end,
        "Charlist (32 + 16 + 8)" => fn ->
          Enum.map(escaped_inputs, &CL_32_16_8.unescape_html_entities/1)
        end
      },
      print: [fast_warning: false]
    )
  end
end

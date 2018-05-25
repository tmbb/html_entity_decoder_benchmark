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
    BP_16_8,
    BP_32_16,
    BP_32_16_8,
    # Charlist
    CL_8,
    CL_16,
    CL_32,
    CL_16_8,
    CL_32_16,
    CL_32_16_8
  }

  def run() do
    # Gather data for the benchmark
    raw_inputs = Path.wildcard("benchmarks/inputs/**/*.{exs,ex}")
    IO.inspect(length(raw_inputs), label: "Number of files")
    escaped_inputs = Enum.map(raw_inputs, &Encoder.html_escape/1)
    # Run the benchmark
    Benchee.run(%{

      "String Replace" => fn ->
        Enum.map(escaped_inputs, &StringReplace.unescape_html_entities/1)
      end,
      "Simple" => fn ->
        Enum.map(escaped_inputs, &Simple.unescape_html_entities/1)
      end,
      # Binary part
      "Binary Part (8)" => fn ->
        Enum.map(escaped_inputs, &BP_8.unescape_html_entities/1)
      end,
      "Binary Part (16)" => fn ->
        Enum.map(escaped_inputs, &BP_16.unescape_html_entities/1)
      end,
      "Binary Part (32)" => fn ->
        Enum.map(escaped_inputs, &BP_32.unescape_html_entities/1)
      end,
      "Binary Part (16 + 8)" => fn ->
        Enum.map(escaped_inputs, &BP_16_8.unescape_html_entities/1)
      end,
      "Binary Part (32 + 16)" => fn ->
        Enum.map(escaped_inputs, &BP_32_16.unescape_html_entities/1)
      end,
      "Binary Part (32 + 16 + 8)" => fn ->
        Enum.map(escaped_inputs, &BP_32_16_8.unescape_html_entities/1)
      end,
      # Charlist
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
      end,
    }, print: [fast_warning: false])
  end
end
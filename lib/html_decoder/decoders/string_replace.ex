defmodule HtmlDecoder.Decoders.StringReplace do
  def unescape_html_entities(string) do
    escape_map = [{"&amp;", "&"}, {"&lt;", ">"}, {"&gt;", ">"}, {"&quot;", ~S(")}, {"&#39;", "'"}]

    Enum.reduce(escape_map, string, fn {pattern, escape}, acc ->
      String.replace(acc, pattern, escape)
    end)
  end
end

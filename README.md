# HtmlDecoder

Compares the performance of several strategies to decode HTML entities in texts
(not nested HTML tags!).
The winning decoder is meant to be used with ExDoc to decode the HTML entities in code blocks so that they can be fed to Makeup for syntax highlighting.

## How to run the benchmark

To run the benchmark, clone the project, get the dependencies and:

```
mix run benchmarks/main.exs
```

## Results (example output)

Example output on my machine:

```text
Compiling 1 file (.ex)
Generated html_decoder app
Operating System: Windows"
CPU Information: Intel(R) Core(TM) i7-6700HQ CPU @ 2.60GHz
Number of Available Cores: 8
Available memory: 7.87 GB
Elixir 1.6.2
Erlang 20.0

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 0 μs
parallel: 1
inputs: none specified
Estimated total run time: 3.03 min

Name                                     ips        average  deviation         median         99th %
Simple                                2.40 K      417.11 μs    ±17.72%         470 μs         470 μs
Binary Part (16)                      2.27 K         440 μs    ±13.92%         470 μs         470 μs
Binary Part (16 + 8)                  2.00 K      501.29 μs    ±12.60%         470 μs         630 μs
Binary Part (8)                       1.99 K      503.10 μs    ±13.81%         470 μs         630 μs
Charlist (16)                         1.93 K      517.11 μs    ±14.10%         470 μs         630 μs
Binary Part (30 + 10)                 1.85 K      539.25 μs    ±14.53%         470 μs         630 μs
Binary Part (32)                      1.85 K      539.94 μs   ±137.80%           0 μs        1600 μs
IEx Aware (12 + 4)                    1.85 K      540.97 μs    ±14.48%         470 μs         630 μs
Binary Part (36 + 12)                 1.80 K      556.37 μs    ±14.01%         620 μs         630 μs
Binary Part (64)                      1.78 K      560.78 μs    ±13.83%         620 μs         630 μs
IEx Aware (32)                        1.75 K      570.65 μs   ±132.02%           0 μs        1600 μs
Charlist (32)                         1.74 K      575.23 μs    ±14.05%         620 μs         780 μs
Charlist (16 + 8)                     1.70 K      590.12 μs    ±11.11%         620 μs         630 μs
Binary Part (32 + 16)                 1.66 K      604.22 μs   ±126.10%           0 μs        1600 μs
Binary Part (32 + 16 + 8)             1.62 K      619.26 μs     ±6.32%         620 μs         780 μs
IEx Aware (36 + 12)                   1.60 K      626.88 μs     ±8.44%         630 μs         780 μs
Charlist (8)                          1.57 K      635.74 μs   ±120.92%           0 μs        1600 μs
Binary Part (27 + 9 + 3)              1.56 K      643.08 μs   ±119.75%           0 μs        1600 μs
Binary Part (64 + 16)                 1.55 K      643.90 μs   ±119.62%           0 μs        1600 μs
Binary Part (42 + 14 + 5)             1.51 K      663.49 μs   ±116.58%           0 μs        1600 μs
Binary Part (36 + 12 + 4)             1.50 K      666.14 μs   ±116.18%           0 μs        1600 μs
Binary Part (64 + 32)                 1.42 K      706.34 μs    ±13.92%         630 μs        1100 μs
Charlist (32 + 16)                    1.39 K      719.51 μs   ±108.40%           0 μs        1600 μs
Charlist (32 + 16 + 8)                1.30 K      769.11 μs   ±439.75%           0 μs       16000 μs
String Replace                        1.26 K      794.93 μs    ±98.45%        1500 μs        1600 μs
Binary Part (64 + 32 + 16 + 8)        1.25 K      801.11 μs     ±6.62%         780 μs         940 μs

Comparison:
Simple                                2.40 K
Binary Part (16)                      2.27 K - 1.05x slower
Binary Part (16 + 8)                  2.00 K - 1.20x slower
Binary Part (8)                       1.99 K - 1.21x slower
Charlist (16)                         1.93 K - 1.24x slower
Binary Part (30 + 10)                 1.85 K - 1.29x slower
Binary Part (32)                      1.85 K - 1.29x slower
IEx Aware (12 + 4)                    1.85 K - 1.30x slower
Binary Part (36 + 12)                 1.80 K - 1.33x slower
Binary Part (64)                      1.78 K - 1.34x slower
IEx Aware (32)                        1.75 K - 1.37x slower
Charlist (32)                         1.74 K - 1.38x slower
Charlist (16 + 8)                     1.70 K - 1.41x slower
Binary Part (32 + 16)                 1.66 K - 1.45x slower
Binary Part (32 + 16 + 8)             1.62 K - 1.48x slower
IEx Aware (36 + 12)                   1.60 K - 1.50x slower
Charlist (8)                          1.57 K - 1.52x slower
Binary Part (27 + 9 + 3)              1.56 K - 1.54x slower
Binary Part (64 + 16)                 1.55 K - 1.54x slower
Binary Part (42 + 14 + 5)             1.51 K - 1.59x slower
Binary Part (36 + 12 + 4)             1.50 K - 1.60x slower
Binary Part (64 + 32)                 1.42 K - 1.69x slower
Charlist (32 + 16)                    1.39 K - 1.73x slower
Charlist (32 + 16 + 8)                1.30 K - 1.84x slower
String Replace                        1.26 K - 1.91x slower
Binary Part (64 + 32 + 16 + 8)        1.25 K - 1.92x slower
```

### Interpretation

There are 4 groups of decoders:

  * A *simple* decoder, which scans the input one byte at a time and decodes the entities as it finds them.

  * A decoder which uses `String.replace`, and is predictably slow as a result.

  * A decoder which tests more than one byte at the same time, looking for the `?&` which marks the beginning of an HTML entity and uses binaries

  * A decoder which tests more than one byte at the same time (as above), but which uses charlists instead of binaries to build the output.

A decoder marked as `(32 + 16)`, for example, first tests 32 bytes, then 16 (if it finds a `?&` byte in the first 32 bytes, and then 1 byte at a time, if it finds a `?&` character in the 16 bytes it has scanned.
After decoding an entity, it starts by trying 32 bytes again, and so on.

**As you can see, the fastest option is to test 1 byte at a time.**

This is probably because the docs of a typical elixir package contains multiple short code fragments, without any long strings of bytes that don't contain an HTML entity.

## What's up with the macro overuse?

I use lots of macros so that I can define decoders declaratively through their parameters.
In real code I'd code the decoders manually, of course, even though they'd end up equal to the ones generated by these macros.

## Validity of these benchmarks

The inputs for these benchmarks are the docs of the `plug` package.
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
Estimated total run time: 2.10 min


Benchmarking Binary Part (16 + 8)...
Benchmarking Binary Part (16)...
Benchmarking Binary Part (32 + 16 + 8)...
Benchmarking Binary Part (32 + 16)...
Benchmarking Binary Part (32)...
Benchmarking Binary Part (64 + 16)...
Benchmarking Binary Part (64 + 32 + 16 + 8)...
Benchmarking Binary Part (64 + 32)...
Benchmarking Binary Part (64)...
Benchmarking Binary Part (8)...
Benchmarking Charlist (16 + 8)...
Benchmarking Charlist (16)...
Benchmarking Charlist (32 + 16 + 8)...
Benchmarking Charlist (32 + 16)...
Benchmarking Charlist (32)...
Benchmarking Charlist (8)...
Benchmarking Simple...
Benchmarking String Replace...

Name                                     ips        average  deviation         median         99th %
Binary Part (32 + 16)                14.11 K       70.86 μs    ±11.03%          78 μs          79 μs
Binary Part (32)                     13.84 K       72.26 μs   ±107.97%           0 μs         160 μs
Binary Part (16)                     13.59 K       73.59 μs    ±10.49%          78 μs          94 μs
Binary Part (32 + 16 + 8)            13.19 K       75.81 μs    ±11.34%          78 μs         110 μs
Binary Part (16 + 8)                 12.52 K       79.86 μs    ±11.82%          78 μs         110 μs
Binary Part (64 + 16)                11.92 K       83.87 μs     ±9.19%          78 μs          94 μs
Charlist (16)                        11.52 K       86.78 μs    ±89.65%         150 μs         160 μs
Binary Part (64 + 32)                11.49 K          87 μs     ±9.05%          93 μs          94 μs
Binary Part (64 + 32 + 16 + 8)       11.36 K          88 μs     ±8.64%          93 μs          94 μs
Charlist (16 + 8)                    11.31 K       88.45 μs    ±87.72%         150 μs         160 μs
Binary Part (8)                      11.11 K       90.05 μs    ±85.92%         150 μs         160 μs
Charlist (32 + 16)                   11.03 K       90.64 μs   ±403.23%           0 μs        1600 μs
Charlist (32)                        10.89 K       91.87 μs    ±83.90%         150 μs         160 μs
Simple                               10.70 K       93.45 μs     ±5.19%          94 μs         110 μs
Charlist (8)                         10.60 K       94.33 μs     ±6.29%          94 μs         110 μs
Charlist (32 + 16 + 8)               10.47 K       95.51 μs     ±5.37%          94 μs         110 μs
Binary Part (64)                      9.29 K      107.64 μs    ±67.39%         150 μs         160 μs
String Replace                        3.02 K      331.19 μs    ±15.22%         310 μs         470 μs

Comparison:
Binary Part (32 + 16)                14.11 K
Binary Part (32)                     13.84 K - 1.02x slower
Binary Part (16)                     13.59 K - 1.04x slower
Binary Part (32 + 16 + 8)            13.19 K - 1.07x slower
Binary Part (16 + 8)                 12.52 K - 1.13x slower
Binary Part (64 + 16)                11.92 K - 1.18x slower
Charlist (16)                        11.52 K - 1.22x slower
Binary Part (64 + 32)                11.49 K - 1.23x slower
Binary Part (64 + 32 + 16 + 8)       11.36 K - 1.24x slower
Charlist (16 + 8)                    11.31 K - 1.25x slower
Binary Part (8)                      11.11 K - 1.27x slower
Charlist (32 + 16)                   11.03 K - 1.28x slower
Charlist (32)                        10.89 K - 1.30x slower
Simple                               10.70 K - 1.32x slower
Charlist (8)                         10.60 K - 1.33x slower
Charlist (32 + 16 + 8)               10.47 K - 1.35x slower
Binary Part (64)                      9.29 K - 1.52x slower
String Replace                        3.02 K - 4.67x slower
```

### Interpretation

There are 4 groups of decoders:

  * A *simple* decoder, which scans the input one byte at a time and decodes the entities as it finds them.

  * A decoder which uses `String.replace`, and is predictably slow as a result.

  * A decoder which tests more than one byte at the same time, looking for the `?&` which marks the beginning of an HTML entity and uses binaries

  * A decoder which tests more than one byte at the same time (as above), but which uses charlists instead of binaries to build the output.

A decoder marked as `(32 + 16)`, for example, first tests 32 bytes, then 16 (if it finds a `?&` byte in the first 32 bytes, and then 1 byte at a time, if it finds a `?&` character in the 16 bytes it has scanned.
After decoding an entity, it starts by trying 32 bytes again, and so on.

**As you can see, the fastest option is to test 32 bytes, then 16 and then 1 byte.**

Testing 64 bytes at a time makes it slower (probably because of multiple retries).

### Approaches not yet tried

Instead of continuously building new binaries, it might be worth it to try to advance the byte location in the input binary.

## What's up with the macro overuse?

I use lots of macros so that I can define decoders declaratively through their parameters.
In real code I'd code the decoders manually, of course, even though they'd end up equal to the ones generated by these macros.

## Validity of these benchmarks

The inputs for these benchmarks are the elixir source code in the `plug` package.

These benchmarks therefore use "raw" elixir source code.
The input to ExDoc often contains doctests, which might suffer a performance hit due to how common the `?>` character is (it's part of the IEx prompt).

These benchmarks should be redone by running the decoders on the output of ExDoc, instead of raw elixir code (the output from the `phoenix` or `plug` docs would be a good choice, probably).
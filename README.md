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
Estimated total run time: 2.68 min


Benchmarking Binary Part (16 + 8)...
Benchmarking Binary Part (16)...
Benchmarking Binary Part (27 + 9 + 3)...
Benchmarking Binary Part (30 + 10)...
Benchmarking Binary Part (32 + 16 + 8)...
Benchmarking Binary Part (32 + 16)...
Benchmarking Binary Part (32)...
Benchmarking Binary Part (36 + 12 + 4)...
Benchmarking Binary Part (36 + 12)...
Benchmarking Binary Part (42 + 14 + 5)...
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
Binary Part (36 + 12)                15.21 K       65.75 μs     ±9.73%          63 μs          79 μs
Binary Part (30 + 10)                14.42 K       69.34 μs    ±11.41%          63 μs          79 μs
Binary Part (36 + 12 + 4)            14.29 K       69.97 μs   ±462.08%           0 μs        1600 μs
Binary Part (32 + 16)                14.16 K       70.65 μs    ±11.07%          78 μs          79 μs
Binary Part (42 + 14 + 5)            14.02 K       71.31 μs    ±10.83%          78 μs          79 μs
Binary Part (32)                     13.91 K       71.87 μs    ±10.70%          78 μs          79 μs
Binary Part (27 + 9 + 3)             13.67 K       73.15 μs    ±10.09%          78 μs          79 μs
Binary Part (16)                     13.63 K       73.38 μs    ±10.00%          78 μs          79 μs
Binary Part (32 + 16 + 8)            13.59 K       73.59 μs     ±9.67%          78 μs          79 μs
Binary Part (16 + 8)                 13.24 K       75.55 μs    ±12.16%          78 μs          94 μs
Binary Part (64 + 16)                11.90 K       84.02 μs    ±92.90%         150 μs         160 μs
Binary Part (8)                      11.68 K       85.60 μs    ±91.03%         150 μs         160 μs
Binary Part (64 + 32)                11.49 K       87.02 μs     ±8.99%          93 μs          94 μs
Charlist (16)                        11.36 K          88 μs    ±88.25%         150 μs         160 μs
Binary Part (64 + 32 + 16 + 8)       11.10 K       90.11 μs    ±10.47%          94 μs         125 μs
Charlist (32 + 16)                   10.90 K       91.76 μs     ±8.13%          94 μs         110 μs
Charlist (16 + 8)                    10.87 K       92.04 μs    ±83.71%         150 μs         160 μs
Charlist (32)                        10.63 K       94.04 μs     ±5.06%          94 μs         110 μs
Charlist (8)                         10.57 K       94.64 μs     ±5.03%          94 μs         110 μs
Simple                               10.57 K       94.64 μs     ±5.97%          94 μs         110 μs
Charlist (32 + 16 + 8)               10.47 K       95.51 μs     ±5.31%          94 μs         110 μs
Binary Part (64)                      9.24 K      108.25 μs    ±66.79%         150 μs         160 μs
String Replace                        2.95 K      338.66 μs    ±17.20%         310 μs         470 μs

Comparison:
Binary Part (36 + 12)                15.21 K
Binary Part (30 + 10)                14.42 K - 1.05x slower
Binary Part (36 + 12 + 4)            14.29 K - 1.06x slower
Binary Part (32 + 16)                14.16 K - 1.07x slower
Binary Part (42 + 14 + 5)            14.02 K - 1.08x slower
Binary Part (32)                     13.91 K - 1.09x slower
Binary Part (27 + 9 + 3)             13.67 K - 1.11x slower
Binary Part (16)                     13.63 K - 1.12x slower
Binary Part (32 + 16 + 8)            13.59 K - 1.12x slower
Binary Part (16 + 8)                 13.24 K - 1.15x slower
Binary Part (64 + 16)                11.90 K - 1.28x slower
Binary Part (8)                      11.68 K - 1.30x slower
Binary Part (64 + 32)                11.49 K - 1.32x slower
Charlist (16)                        11.36 K - 1.34x slower
Binary Part (64 + 32 + 16 + 8)       11.10 K - 1.37x slower
Charlist (32 + 16)                   10.90 K - 1.40x slower
Charlist (16 + 8)                    10.87 K - 1.40x slower
Charlist (32)                        10.63 K - 1.43x slower
Charlist (8)                         10.57 K - 1.44x slower
Simple                               10.57 K - 1.44x slower
Charlist (32 + 16 + 8)               10.47 K - 1.45x slower
Binary Part (64)                      9.24 K - 1.65x slower
String Replace                        2.95 K - 5.15x slower
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
# ElixirML

Deep learning in Elixir using [Erlang NIFs](https://www.erlang.org/doc/tutorial/nif.html).
Written in C which uses native the MacOS BLAS implementation through [vecLib](https://developer.apple.com/documentation/accelerate/veclib) for processing.

## Requirements

- MacOS with XCode Command Line Tools
- Elixir 14.4+

## Installation

```console
$ git clone https://github.com/RisGar/elixir_ml
$ cd elixir_ml
$ ./datasets.sh
$ mix deps.get
```

Then run any of the provided mix tasks:

- xor
- mnist

## Attributions

- [versilov/matrex](https://github.com/versilov/matrex): Erlang NIFs implementation incl. build system

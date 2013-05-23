sudoku\_bardi
=============

## Summary

Sudoku solver, validator and generator

## Description

sudoku\_bardi (see websudoku.com) is a set of tools for solving, validating and generating Sudoku puzzles.

## Why should one the sudoku\_bardi tools?

The Sudoku solution algorithm does not use recursion -- runs in limited memory and can find all solutions of incorrect puzzles.

## Version

v0.1.0 with comprehensive tests, was developed using ruby 1.9.3 and rspec 2.13.0. It does not have any specific Sudoku puzzle generators yet; however it provides a good foundation for any generator as it provides validation of solution uniqueness and shows the operations used in the puzzle solution(s).

## Installation

Get the v0.1.0 gem or clone the repository.

## Usage and documentation

Study the programs in the spec/ directory. See below for more information.

Try the software in irb:

    irb prompt> load 'lib/sudoku_bardi.rb'
    irb prompt> load 'spec/support/sudoku_fixture.rb'
    irb prompt> include SudokuBardi
    irb prompt> include SudokuFixture
    irb prompt> s = Solver.new EXAMPLE2
    irb prompt> s.take 1

After -- s.take 1 -- one will see a listing of an array of size 2. The 0 element is an array of operations made to get the solution. The 1 element is the solution.

    [75, SudokuBardi::Five] means assign Five to square 75.
    ["start"] ends the operations to construct the puzzle.
    ["mark", 2, [SudokuBardi::Seven, SudokuBardi::Two], 1]
      shows a backtrack mark for square 2. That type of thing
      occurs when there is no longer any square with only one
      possible value. The solver had to try Seven and Two to
      get all possible solutions. The 1 points at Two as the
      current value chosen.

      0  1  2  3  4  5  6  7  8
      9 10 11 12 13 14 15 16 17
     18 19 20 21 22 23 24 25 26
     27 28 29 30 31 32 33 34 35
     36 37 38 39 40 41 42 43 44
     45 46 47 48 49 50 51 52 53
     54 55 56 57 58 59 60 61 62
     63 64 65 66 67 68 69 70 71
     72 73 74 75 76 77 78 79 80

## Requirements

Most likely any recent version of 1.9 ruby works.

## Test with rspec ~> 2.11, rspec -fd

Try the software in irb:

    irb prompt> load 'spec/support/sudoku_bardi_test.rb'
    irb prompt> load 'spec/support/sudoku_fixture.rb'

Note, to find the gem installation directory:

    irb prompt> require 'sudoku_bardi'
    irb prompt> $".grep(/sudoku_bardi/)[0]
    irb prompt> Sudoku::Solver.new.method(:each).source_location
    irb prompt> exit

## License

Copyright (c) 2013 Bardi Einarsson. Released under the MIT License.  See the [LICENSE][license] file for further details.

[license]: https://github.com/bardibardi/sudoku_bardi/blob/master/LICENSE.md

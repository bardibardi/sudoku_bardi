require 'support/no_should_rspec'
require 'support/sudoku_bardi_test'
require 'support/sudoku_fixture'
include SudokuFixture

describe SudokuBardi::Solver do

  it "should solve puzzles with unique solutions" do
    expect(SudokuBardi.unique_solution?(EXAMPLE, SOLUTION)).to be_true
    expect(SudokuBardi.unique_solution?(EXAMPLE2, SOLUTION2)).to be_true
    expect(SudokuBardi.unique_solution?(EXAMPLE3, SOLUTION3)).to be_true
  end

  it "should solve puzzles with multiple solutions" do
    expect(SudokuBardi.empty_puzzle_has_at_least_100_solutions?).to be_true
  end

end

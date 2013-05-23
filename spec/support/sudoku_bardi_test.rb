require_relative '../../lib/sudoku_bardi'

module SudokuBardi

  def self.unique_solution? puzzle_board, solution_board
    s = Solver.new puzzle_board
    solutions = s.take 2
    return nil unless 1 == solutions.size
    solutions[0][1] == solution_board
  end

  def self.empty_puzzle_has_at_least_100_solutions?
    s = Solver.new
    solutions = s.take 100
    100 == solutions.size
  end

end # SudokuBardi


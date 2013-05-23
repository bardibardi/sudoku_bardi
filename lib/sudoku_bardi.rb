module SudokuBardi

# row, column, box
RCB = [
[0,0,0],[0,1,0],[0,2,0],[0,3,1],[0,4,1],[0,5,1],[0,6,2],[0,7,2],[0,8,2],
[1,0,0],[1,1,0],[1,2,0],[1,3,1],[1,4,1],[1,5,1],[1,6,2],[1,7,2],[1,8,2],
[2,0,0],[2,1,0],[2,2,0],[2,3,1],[2,4,1],[2,5,1],[2,6,2],[2,7,2],[2,8,2],
[3,0,3],[3,1,3],[3,2,3],[3,3,4],[3,4,4],[3,5,4],[3,6,5],[3,7,5],[3,8,5],
[4,0,3],[4,1,3],[4,2,3],[4,3,4],[4,4,4],[4,5,4],[4,6,5],[4,7,5],[4,8,5],
[5,0,3],[5,1,3],[5,2,3],[5,3,4],[5,4,4],[5,5,4],[5,6,5],[5,7,5],[5,8,5],
[6,0,6],[6,1,6],[6,2,6],[6,3,7],[6,4,7],[6,5,7],[6,6,8],[6,7,8],[6,8,8],
[7,0,6],[7,1,6],[7,2,6],[7,3,7],[7,4,7],[7,5,7],[7,6,8],[7,7,8],[7,8,8],
[8,0,6],[8,1,6],[8,2,6],[8,3,7],[8,4,7],[8,5,7],[8,6,8],[8,7,8],[8,8,8]
]

class Piece; end
class One < Piece; end
class Two < Piece; end
class Three < Piece; end
class Four < Piece; end
class Five < Piece; end
class Six < Piece; end
class Seven < Piece; end
class Eight < Piece; end
class Nine < Piece; end

TO_S = { nil => '.',
  One => '1', Two => '2', Three => '3',
  Four => '4', Five => '5', Six => '6',
  Seven => '7', Eight => '8', Nine => '9'
}

NINE = [One, Two, Three, Four, Five, Six, Seven, Eight, Nine]

class Solver

  include Enumerable

  def self.piece_from_char c
    i = c.bytes.first - 49 # 49 == '0'.bytes.first + 1
    return nil if 0 > i
    NINE[i]
  end

  def self.constraint c
    a = []
    c.size.times do
      a << c.dup
    end
    a
  end

  def initialize board_str = ''
    start
    process board_str
    push ['start']
  end

  def start 
    @board = [nil] * (NINE.size * NINE.size)
    @rows = self.class.constraint NINE
    @columns = self.class.constraint NINE
    @boxes = self.class.constraint NINE 
    @ops = []
  end

  def board_to_s
    a = @board.map do |piece|
      TO_S[piece]
    end
    a.join ''
  end

  def possible i
    r, c, b = RCB[i]
    @rows[r] & @columns[c] & @boxes[b]
  end

  def do_op op
    i, piece = op
    r, c, b = RCB[i]
    @rows[r] -= [piece]
    @columns[c] -= [piece]
    @boxes[b] -= [piece]
    @board[i] = piece
    op
  end

  def undo_op op
    i, piece = op
    r, c, b = RCB[i]
    @rows[r] += [piece]
    @columns[c] += [piece]
    @boxes[b] += [piece]
    @board[i] = nil
    op
  end

  def pop_start
    @ops.pop
  end

  def push_start
    push ['start']
  end

  def pop
    return nil if 'start' == @ops[-1][0]
    @ops.pop
  end

  def push op
    @ops << op
  end

  def process_str str_as_ops
    ops = []
    str_as_ops.each_char.with_index do |char, i|
      piece = self.class.piece_from_char char
      if piece
        ps = possible i
        raise "impossible #{char} at #{i}" unless ps.include? piece
        push do_op([i, piece])
      end
    end
    ops
  end

  def play ops
    ops.each do |op|
      push do_op(op)
    end
  end

  def process board_str
    play process_str(board_str)
  end

  def single i
    processed_single = false
    backtrack = false
    ps = possible i
    if 0 == ps.length
      backtrack = true
    end
    if 1 == ps.length
      processed_single = true
      push do_op([i, ps[0]])
    end
    [processed_single, backtrack]
  end

  def singles
    had_singles = true
    finished = true
    while had_singles
      finished = true
      single_found = false
      @board.each_with_index do |piece, i|
        if !piece
          finished = false
          processed_single, backtrack = single i
          single_found ||= processed_single
          if backtrack
            push ['backtrack', i]
            return finished
          end
        end
      end
      had_singles = single_found
    end
    finished
  end

  def min_choices
    j = nil
    count = 10
    @board.each_with_index do |piece, i|
      if !piece
        len = possible(i).size
        if len < count
          j = i
          count = len
        end
      end
    end
    j
  end

  def gen_choices
    a = []
    @board.each_with_index do |piece, i|
      if !piece
        ps = possible(i)
        if 1 < ps.size
          a += ps.map {|e| [i, e]}
        end
      end
    end
    a
  end

  def add_mark i
    push ['mark', i, possible(i), -1]
  end

  def try
    mark = pop.dup
    mark[3] += 1
    piece = mark[2][mark[3]]
    push mark
    if piece
      push do_op([mark[1], piece])
    else
      push ['backtrack', mark[1]]
    end
  end

  def do_backtrack
    pop if 'mark' == @ops[-1][0]
    op = pop
    if op
      while 'mark' != op[0]
        undo_op op if op[0].kind_of? Numeric
        op = pop
        return @ops unless op
      end
    end
    push op if op
  end

  def solve_one
    solved = false
    until solved
      if 'backtrack' == @ops[-1][0]
        pop
        do_backtrack
        if 'start' == @ops[-1][0]
          return nil
        end
        try
      else
        solved = singles
        if !solved
          i = min_choices
          add_mark i
          try
        end
      end
    end
    [@ops, board_to_s]
  end

  def each
    first = true
    finished = false
    until finished
      push ['backtrack', 81] unless first
      first = false
      result = solve_one
      if result
        yield [result[0].dup, result[1]]
      else
        finished = true
      end
    end
  end

end # Solver

end # SudokuBardi


require 'prawn'
require 'wordsearch/grid'

module WordSearch
  class Puzzle
    DIRS = {
      right:     [ 0,  1],
      left:      [ 0, -1],
      up:        [-1,  0],
      down:      [ 1,  0],
      rightdown: [ 1,  1],
      rightup:   [-1,  1],
      leftdown:  [ 1, -1],
      leftup:    [-1, -1]
    }

    attr_reader :vocabulary
    attr_reader :rows
    attr_reader :columns
    attr_reader :seed

    attr_reader :unused_squares

    attr_reader :grid
    attr_reader :solution

    def initialize(vocabulary, rows: 15, columns: 15, diagonal: false, backward: false, message: nil, seed: Time.now.to_i)
      @vocabulary = vocabulary

      @rows = rows
      @columns = columns
      @diagonal = diagonal
      @backward = backward
      @message = message
      @seed = seed

      srand(@seed)

      _generate!
    end

    def _generate!
      words = @vocabulary.dup

      directions = %i(right down)
      directions += %i(rightdown) if @diagonal
      directions += %i(left up) if @backward
      directions += %i(leftup leftdown rightup) if @diagonal && @backward

      grid = WordSearch::Grid.new(@rows, @columns)
      positions = (0...grid.size).to_a
      stack = [ { grid: grid, word: words.shift, dirs: directions.shuffle, positions: positions.shuffle } ]

      while true
        current = stack.last
        raise "no solution possible" if !current

        dir = current[:dirs].pop
        if dir.nil?
          current[:positions].pop
          current[:dirs] = directions.shuffle
          dir = current[:dirs].pop
        end

        pos = current[:positions].last

        if pos.nil?
          words.unshift(current[:word])
          stack.pop
        else
          grid = _try_word(current[:grid], current[:word], pos, dir)
          if grid
            if words.any?
              stack.push(grid: grid, word: words.shift, dirs: directions.shuffle,
                positions: positions.shuffle)
            else
              break # success!
            end
          end
        end
      end

      @grid = grid
      @solution = grid.dup

      @unused_squares = @grid.fill!(@message)
    end

    def _try_word(grid, word, position, direction)
      copy = grid.dup
      row, column = copy.at(position)

      dr, dc = DIRS[direction]
      letters = word.chars

      while (row >= 0 && row < copy.rows) && (column >= 0 && column < copy.columns)
        letter = letters.shift || break

        if copy[row, column].nil? || copy[row, column] == letter
          copy[row, column] = letter
          row += dr
          column += dc
        else
          return nil
        end
      end

      letters.any? ? nil : copy
    end

    def to_s(solution: false)
      s = ""

      @rows.times do |row|
        @columns.times do |col|
          s << " " if col > 0
          if solution
            s << (@solution[row, col] || ".")
          else
            s << @grid[row, col]
          end
        end
        s << "\n"
      end

      s
    end

    def to_pdf(box_size: 18, margin: 18, font_name: "Helvetica", clue_font: font_name, solution: true, clues: true)
      height = box_size * @rows
      width = box_size * @columns

      pdf = Prawn::Document.new(skip_page_creation: true)

      if clues
        clue_height = height.to_f / @vocabulary.length
        clue_height = box_size if clue_height > box_size
        clue_font_size = clue_height * 0.7
        clue_margin = 72 / 4.0

        font = Prawn::Font.load(pdf, clue_font)
        max = @vocabulary.map { |word| font.compute_width_of(word, size: clue_font_size)+1 }.max

        width += clue_margin + max
      end

      pages = solution ? 2 : 1

      pages.times do |page|
        pdf.start_new_page(
          size: [width+margin*2, height+margin*2],
          margin: margin)

        pdf.font font_name, size: box_size*0.7

        @rows.times do |row|
          y = (@rows - row) * box_size

          @columns.times do |col|
            x = col * box_size
            pdf.bounding_box [x, y], width: box_size, height: box_size do
              pdf.text(@grid[row, col].upcase, align: :center, valign: :center,
                color: ((page == 1 && @solution[row, col]) ? "ff0000" : "000000"))
            end
          end
        end

        if clues
          pdf.font clue_font
          x = @columns * box_size + clue_margin
          @vocabulary.each.with_index do |word, index|
            y = (@rows * box_size) - index * clue_height
            pdf.text_box word, at: [x, y], height: clue_height, size: clue_font_size, valign: :center
          end
        end
      end

      pdf
    end
  end
end

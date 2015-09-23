module WordSearch
  class Grid
    attr_reader :rows, :columns, :size

    def initialize(rows, columns, grid=nil)
      @rows, @columns = rows, columns
      @size = @rows * @columns
      @grid = grid || Array.new(@rows * @columns)
    end

    def index(row_or_pos, column=nil)
      if column
        row_or_pos * @columns + column
      else
        row_or_pos
      end
    end

    def at(position)
      row = position / @columns
      col = position % @columns
      [row, col]
    end

    def [](row_or_pos, column=nil)
      @grid[index(row_or_pos, column)]
    end

    def []=(row_or_pos, *args)
      if args.length == 1
        column = nil
        value = args.first
      elsif args.length == 2
        column = args.first
        value = args.last
      else
        raise ArgumentError, "expected 2..3 arguments"
      end

      @grid[index(row_or_pos, column)] = value
    end

    def dup
      self.class.new(@rows, @columns, @grid.dup)
    end

    def fill!(message=nil)
      message = (message || "").downcase.gsub(/[^a-z]/, "").chars
      unused = @grid.select { |n| n.nil? }.length
      letters = ('a'..'z').to_a
      @size.times { |pos| @grid[pos] ||= (message.shift || letters.sample) }
      unused
    end
  end
end

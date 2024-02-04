# frozen_string_literal: true

require_relative 'game_board'
require_relative 'player'
require_relative 'move_converter'

class Chess
  def initialize(position = nil)
    @game_board = GameBoard.new(position)
    @player1 = Player.new('W')
    @player2 = Player.new('B')
    @move_converter = MoveConverter.new
    @current_player = @player1
  end

  def game_loop
    loop do
      legal_moves = @game_board.legal_moves(@current_player.color)
      puts
      puts @current_player.color
      puts @game_board.display
      p legal_moves
      accepted_move = false
      until accepted_move
        move = @current_player.ask_move
        converted_move = @move_converter.convert(move, @current_player.color)
        accepted_move = in_legal_moves(converted_move, legal_moves)
      end
      @game_board.move_piece(accepted_move)
      next_player
    end
  end

  def in_legal_moves(move, legal_moves)
    matches = legal_moves.select { |legal_move| legal_move[0] == move[0] && legal_move[2] == move[2] }
    case matches.length
    when 0
      false
    when 1
      matches[0]
    else
      # Disambiguation - original row&col, row, column
      row_col = matches.select { |match| match[1] == move[1] }
      return row_col[0] if row_col.length == 1

      row = matches.select { |match| match[1][0] == move[1][0] }
      return row[0] if row.length == 1

      col = matches.select { |match| match[1][1] == move[1][1] }
      return col[0] if col.length == 1

      false
    end
  end

  def next_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end

# starting_board = %w[
#   rnbqkbnr
#   pppppppp
#   ........
#   ........
#   ........
#   ........
#   PPPPPPPP
#   RNBQKBNR
# ]
# Chess.new(starting_board).game_loop
# class for board
class Board
  attr_reader :board, :new_board

  def initialize
    @board = Array.new(9) { |n| n + 1 }
  end

  # Method where it displays the current game board
  def display_board
    puts "\n
    #{board[0]} | #{board[1]} | #{board[2]}
    --+---+--
    #{board[3]} | #{board[4]} | #{board[5]}
    --+---+--
    #{board[6]} | #{board[7]} | #{board[8]}
    \n"
  end

  # Method where it converts the location numbers to array form where it starts from 0 instead of 1
  def update_board(symbol, location)
    board[location - 1] = symbol
    display_board
  end

  # Method where it defines all the ways one can win horizontally
  def row_win?(symbol)
    board[0..2].all? { |sym| sym == symbol } ||
      board[3..5].all? { |sym| sym == symbol } ||
      board[6..8].all? { |sym| sym == symbol }
  end

  # Method where it defines all the ways one can win vertically
  def column_win?(symbol)
    board.values_at(0, 3, 6).all? { |sym| sym == symbol } ||
      board.values_at(1, 4, 7).all? { |sym| sym == symbol } ||
      board.values_at(2, 5, 8).all? { |sym| sym == symbol }
  end

  # Method where it defines all the ways one can win diagonally
  def diagonal_win?(symbol)
    board.values_at(0, 4, 8).all? { |sym| sym == symbol } ||
      board.values_at(2, 4, 6).all? { |sym| sym == symbol }
  end

  # Method where the input entered is checked if it is a number
  def legal_move?(location)
    return true if board[location - 1].is_a?(Numeric)
  end
end

# class for players
class Player
  attr_reader :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  # Method where ask the current player where it wants to place its mark on the current game board
  def player_move
    puts "#{@name}, where would you like to play?"
    location = gets.chomp until location.to_i.between?(1, 9)
    location.to_i
  end

  # Method where it checks whether a player has won the game
  def player_win?(board)
    board.row_win?(symbol) || board.column_win?(symbol) || board.diagonal_win?(symbol)
  end

  # Method where it outputs a message after a player has won
  def congratulate_winner
    puts "Congrats #{@name}, you win!"
  end
end

# game loop class
class Game
  attr_reader :game_board, :player_one, :player_two, :moves, :current_player

  def initialize
    @game_board = Board.new
    @moves = 1
    start_game
  end

  # Method where it loops until all the 9 available spots have been choosen
  def game_loop
    while @moves <= 9
      move = game_move
      game_board.update_board(current_player.symbol, move)
      if current_player.player_win?(game_board)
        current_player.congratulate_winner
        break
      end
      @current_player = change_current_player
      @moves += 1
    end
  end

  # Method where a move is assign to player who makes it
  def game_move
    move = current_player.player_move
    move = current_player.player_move until game_board.legal_move?(move)
    move
  end

  # Method where the methods calls happen
  def start_game
    puts "\nWelcome to Tic-Tac-Toe!\n\n"
    assign_player_one
    assign_player_two
    game_board.display_board
    game_loop
    tie_message if moves == 10
    ask_for_new_game
  end

  # Method where it assigns the name to player one when asked
  def assign_player_one
    puts 'Player one, enter your name: '
    @player_one = Player.new(gets.chomp, 'X')
    @current_player = player_one
    puts "\n"
  end

  # Method where it assigns the name to player two when asked
  def assign_player_two
    puts 'Player two, enter your name: '
    @player_two = Player.new(gets.chomp, 'O')
  end

  # Method where it alternates from player one to player two
  def change_current_player
    current_player == player_one ? player_two : player_one
  end

  # Method where it outputs a message when the game results in a tie
  def tie_message
    puts "It's a tie, no one won :("
  end

  # Method where after a game is played, it will output a message of Y or N and ask for input. According
  #   to what you input it will do something different
  def ask_for_new_game
    puts "\nWould you like to play a new game? [Y/N]"
    answer = gets.chomp
    answer = gets.chomp until answer.downcase == 'y' || answer.downcase == 'n'
    if answer.downcase == 'y'
      Game.new
    else
      puts "\nGood Bye!"
    end
  end
end

Game.new

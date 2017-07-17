require 'pry'

class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def [](num)
    @squares[num]
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

class Player
  WINNING_ROUNDS = 5
  attr_accessor :marker
  attr_accessor :score

  def initialize(marker)
    @marker = marker
    @score = 0
  end

  def reset_score
    @score = 0
  end

  def add_win
    @score += 1
  end

  def overall_winner?
    @score == WINNING_ROUNDS
  end
end

class Human < Player
  NAME = "Human"

  attr_accessor :name

  def initialize(marker)
    @name = name
    super
  end
end

class Computer < Player
  NAME = "Hal"

  attr_reader :name

  def initialize(marker)
    @name = NAME
    super
  end

  def control_square_five(board, computer)
    if board[5].unmarked?
      5
    else
      nil
    end
  end

  def find_winnning_square(line, board)
    if board.squares.values_at(*line).collect(&:marker).count(marker) == 2
      board.squares.select{ |k, v| line.include?(k) && v.unmarked? }.keys.first
    else
      nil
    end
  end

  def find_losing_square(line, board, human)
    if board.squares.values_at(*line).collect(&:marker).count(human.marker) == 2
      board.squares.select{ |k, v| line.include?(k) && v.unmarked? }.keys.first
    else
      nil
    end
  end




  def moves

  end

end

class TTTGame
  human_marker = "X" # The default human marker
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = human_marker

  attr_reader :board, :human, :computer, :human_marker

  def initialize
    @board = Board.new
    @human = Human.new(human_marker)
    @computer = Computer.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message
    choose_human_name
    choose_human_marker
    choose_first_player

      loop do
        display_board

        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board if human_turn?
        end

        display_result
        if someone_won_overall?
          display_overall_winner
          break
        end
        break unless play_again?
        reset
        display_play_again_message
      end

    display_goodbye_message
  end

  private

  def choose_human_name
    input = nil
    loop do
      puts "Please enter your name:"
      input = gets.chomp.strip
      break unless input == ""
      puts "Sorry, must enter a valid name!"
    end
    human.name = input
  end

  def choose_human_marker
    input = nil
    loop do 
      puts "Please enter a character to use as your game marker:"
      input = gets.chomp.upcase
      break unless input != " " && input.size != 1
      puts "Sorry, invalid input - please choose a single character!"
    end

    human.marker = input
  end

  def choose_first_player
    input = nil
    loop do 
      puts "Who do you want to play first? Choose (1) for #{human.name}" \
      " or (2) for #{computer.name}: "
      input = gets.chomp.to_s.strip
      break if %w(1 2).include?(input)
      puts "Invalid input - must enter (1) or (2)"
    end

    if input == "1"
      @current_marker = human.marker
    else
      @current_marker = COMPUTER_MARKER
    end
  end

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe! First to 5 wins it all!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_wins
    puts "#{human.name}: #{human.score} wins | #{computer.name}: #{computer.score} wins"
    puts ""
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name} is a #{computer.marker}"
    puts ""
    display_wins
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(array, separator=', ', last_word='or')
  temp_array = array.dup  # Create a new array for display purposes 

  if array.size == 1
    return array.first
  else    
    last_num = temp_array.pop
    temp_array.join(separator) << "#{separator}#{last_word} " << last_num.to_s
  end
end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = nil

    # Avoid losing
    Board::WINNING_LINES.each do |line|
      square = computer.find_losing_square(line, board, human)
      break if square
    end
    
    if !square
      # First try to win:
      Board::WINNING_LINES.each do |line|
        square = computer.find_winnning_square(line, board)
        break if square
      end
    end

    # If Square 5 is available, pick square 5
    if !square
      square = computer.control_square_five(board, computer)
    end

    if !square
      square = board.unmarked_keys.sample
    end    
    
    board[square] = computer.marker
    #binding.pry
  end

  def display_result
    display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
      human.add_win
    when computer.marker
      puts "Computer won!"
      computer.add_win
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w[y n].include?(answer)
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def someone_won_overall?
    human.overall_winner? || computer.overall_winner?
  end

  def return_overall_winner
    if human.score == 5
      human
    else
      computer
    end
  end

  def display_overall_winner
    puts "#{return_overall_winner} won the game!"
    puts ""
  end
end

# we'll kick off the game like this
game = TTTGame.new
game.play

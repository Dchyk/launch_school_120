require 'pry'

class GameHistory
  attr_accessor :history, :game_number

  def initialize
    @history = {}
    @game_number = 1
  end

  def update(human_move, computer_move, round_winner)
    self.history[self.game_number] = { computer: computer_move.to_s,
                                          human: human_move.to_s, 
                                          winner: round_winner.to_s }
  end

  def increment_game_number
    self.game_number += 1
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  WINNING_MOVES = {'rock' => ['scissors', 'lizard'],
             'paper' => ['rock', 'spock'],
             'scissors' => ['paper', 'lizard'],
             'lizard' => ['spock', 'paper'],
             'spock' => ['scissors', 'rock']}

  LOSING_MOVES = {'rock' => ['paper', 'spock'],
             'paper' => ['scissors', 'lizard'],
             'scissors' => ['rock', 'spock'],
             'lizard' => ['rock', 'scissors'],
             'spock' => ['lizard', 'paper']}

  attr_reader :value

  def initialize(value)
    @value = value
  end

  # Decreased the cyclomatic complexity dramatically by using a constant to 
  # hold the winning and losing move comparisons for the > and < methods

  def >(other_move)
    WINNING_MOVES[self.value].include?(other_move.value)
  end

  def <(other_move)
    LOSING_MOVES[self.value].include?(other_move.value)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ''

    loop do
      system 'clear'
      puts "Hi there - What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end

    self.name = n
  end

  def choose
    choice = nil

    loop do
      system 'clear'
      puts ""
      puts "Please choose (r)ock, (p)aper, (sc)issors, (l)izard, or (s)pock:"
      short_choice = gets.chomp

      Move::VALUES.each do |move|
        if move.start_with?(short_choice.downcase)
          choice = move
        end
      end
      break if choice != nil
      puts "Sorry, invalid choice."
    end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Score
  attr_accessor :wins

  def initialize
    @wins = 0
  end

  def add_win
    self.wins += 1
  end

  def ten_wins?
    self.wins >= 10
  end

  def reset
    self.wins = 0
  end
end

class RPSGame
  attr_accessor :human, :computer, :human_score, :comp_score, :game_data,
                :round_winner

  def initialize
    self.human = Human.new
    self.computer = Computer.new
    self.human_score = Score.new
    self.comp_score = Score.new
    self.game_data = GameHistory.new
  end

  def play
    display_welcome_message

    loop do
      loop do
        players_choose
        record_winner
        game_data.update(human.move, computer.move, @round_winner)
        display_game_results
        display_wins
        if player_has_ten_wins?
          display_overall_winner
          break
        end
        break unless play_again?
        game_data.increment_game_number
      end

      if new_game_same_players?
        reset_score
      else
        break
      end
    end

    display_game_history
    display_goodbye_message
  end

  private

  def display_welcome_message
    loop do
      system 'clear' 
      puts "Hello, #{human.name}, and welcome to Rock, Paper, Scissors," \
           " Lizard, Spock!"
      puts ""
      puts "Your opponent today is #{computer.name}."
      puts ""
      puts "The first player to win 10 rounds wins the whole game!"
      puts
      puts "Press ENTER when you're ready to play!"
      input = gets.chomp
      break if input
    end
  end

  def players_choose
    human.choose
    computer.choose
  end

  def record_winner
    if human.move > computer.move
      human_score.add_win
      self.round_winner = human.name
    elsif human.move < computer.move
      comp_score.add_win
      self.round_winner = computer.name
    else
      self.round_winner = 'No one'
    end
  end

  def record_game_data
    record_winner
    store_game_history
  end

  def display_game_results
    display_moves
    display_winner
  end

  def display_moves
    puts ""
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    puts ""
    puts "#{self.round_winner} won!"
  end

  def display_wins
    puts ""
    puts "*** Score ***"
    puts "#{human.name}: #{human_score.wins}"
    puts "#{computer.name}: #{comp_score.wins}"
  end

  # Better scoreboard?

  def score_size
    human_chars = human.name.to_s.size
    comp_chars  = computer.name.to_s.size

    if human_chars > comp_chars
      human_chars
    else
      comp_chars
    end

  end

  def display_scoreboard

    width = score_size + 3

    first_row    = '+-' + '-'*width + '-+'
    second_row   = '| ' + "#{human.name}: #{human_score.wins}" + ' |'
    third_row    = '| ' + "#{computer.name}: #{comp_score.wins}" + ' |'
    fourth_row   = first_row

    puts first_row
    puts second_row.center(width)
    puts third_row.center(width)
    puts fourth_row
  end

  def display_overall_winner
    puts ""
    puts "#{human.name} is the overall winner!" if human_score.ten_wins?
    puts "#{computer.name} is the overall winner!" if comp_score.ten_wins?
  end

  def player_has_ten_wins?
    human_score.ten_wins? || comp_score.ten_wins?
  end

  def play_again?
    answer = nil
    loop do
      puts ""
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def new_game_same_players?
    answer = nil
    loop do
      puts ""
      puts "Would you like to play again with the same players? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def reset_score
    human_score.reset
    comp_score.reset
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end

  def display_game_history
    loop do
      puts ""
      puts "Would you like to view the entire game history?"
      puts "Press (y) to view history, or any other key to quit:"
      answer = gets.chomp
      if answer.downcase == 'y'
        game_data.history.each do |game, data|
          puts "Game #{game}. #{computer.name}: #{data[:computer]} " \
                            " #{human.name}: #{data[:human]}" \
                            " #{data[:winner]} won!" 
        end
        break
      else
        break
      end
    end
  end

end

RPSGame.new.play

require 'pry'

class GameHistory
  attr_accessor :history, :game

  def initialize
    @history = {}
    @game = 1
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.spock? || other_move.paper?)) ||
      (spock? && (other_move.scissors? || other_move.rock?))
  end

  def <(other_move)
    (rock? && (other_move.paper? || other_move.spock?)) ||
      (paper? && (other_move.scissors? || other_move.lizard?)) ||
      (scissors? && (other_move.rock? || other_move.spock?)) ||
      (lizard? && (other_move.rock? || other_move.scissors?)) ||
      (spock? && (other_move.lizard? || other_move.paper?))
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
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end

    self.name = n
  end

  def choose
    choice = nil

    loop do
      puts "Please choose rock, paper, scissors, lizard, or spock:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
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

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors! First to 10 wins overall!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper Scissors. Good bye!"
  end

  def display_moves
    puts ""
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def record_winner
    if human.move > computer.move
      human_score.add_win
      self.round_winner = human.name
    elsif human.move < computer.move
      comp_score.add_win
      self.round_winner = computer.name
    end
  end

  def display_winner
    puts ""
    puts "#{@round_winner} won!"
  end

  def display_wins
    puts ""
    puts "#{human.name} has #{human_score.wins} wins."
    puts "#{computer.name} has #{comp_score.wins} wins."
  end

  def display_overall_winner
    puts ""
    puts "#{human.name} is the overall winner!" if human_score.ten_wins?
    puts "#{computer.name} is the overall winner!" if comp_score.ten_wins?
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

  def store_game_history
    game_data.history[game_data.game] = { computer: computer.move.to_s,
                                          human: human.move.to_s, winner: round_winner.to_s }
  end

  def increment_game_number
    game_data.game += 1
  end

  def display_game_history
    puts ""
    game_data.history.each do |game, data|
      puts "Game #{game}. #{computer.name}: #{data[:computer]} " \
                        " #{human.name}: #{data[:human]}" \
                        " #{round_winner} won!"
    end
  end

  def players_choose
    human.choose
    computer.choose
  end

  def record_game_data
    record_winner
    store_game_history
  end

  def display_game_results
    display_moves
    display_winner
    display_wins
  end

  def player_has_ten_wins?
    human_score.ten_wins? || comp_score.ten_wins?
  end

  def play
    display_welcome_message

    loop do
      system 'clear'
      players_choose
      record_game_data
      display_game_results
      display_game_history
      if player_has_ten_wins?
        display_overall_winner
        break
      end
      break unless play_again?
      increment_game_number
    end
    display_goodbye_message
  end
end

RPSGame.new.play

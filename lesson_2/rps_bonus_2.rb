require 'pry'

class GameHistory
  attr_accessor :history, :game_number

  def initialize
    @history = {}
    @game_number = 1
  end

  def update(human_move, computer_move, round_winner)
    history[game_number] = { computer: computer_move.to_s,
                             human: human_move.to_s,
                             winner: round_winner.to_s }
  end

  def increment_game_number
    self.game_number += 1
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  WINNING_MOVES = { 'rock' => ['scissors', 'lizard'],
                    'paper' => ['rock', 'spock'],
                    'scissors' => ['paper', 'lizard'],
                    'lizard' => ['spock', 'paper'],
                    'spock' => ['scissors', 'rock'] }

  LOSING_MOVES = { 'rock' => ['paper', 'spock'],
                   'paper' => ['scissors', 'lizard'],
                   'scissors' => ['rock', 'spock'],
                   'lizard' => ['rock', 'scissors'],
                   'spock' => ['lizard', 'paper'] }

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_MOVES[value].include?(other_move.value)
  end

  def <(other_move)
    LOSING_MOVES[value].include?(other_move.value)
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
      puts "Hi there - What's your name?"
      n = gets.chomp.strip
      break unless n.empty? || n.squeeze == ' '
      system 'clear'
      puts "Sorry, must enter a value."
    end

    self.name = n
  end

  def choose
    choice = nil

    loop do
      puts "Please choose (r)ock, (p)aper, (sc)issors, (l)izard, or (s)pock:"
      short_choice = gets.chomp

      Move::VALUES.each do |move|
        if move.start_with?(short_choice.downcase)
          choice = move
        end
      end
      break unless choice.nil?
      system 'clear'
      puts "Sorry, #{short_choice} is an invalid choice."
      puts ""
    end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  def analyze_wins(game_history)
    moves_that_won = []
    game_history.each_value do |game_info|
      if game_info[:winner] == name.to_s
        moves_that_won << game_info[:computer]
      end
    end
    moves_that_won
  end

  def analyze_losses(game_history, human)
    moves_that_lost = []
    game_history.each do |_, game_info|
      moves_that_lost << game_info[:computer] if game_info[:winner] ==
                                                 human.name.to_s
    end
    moves_that_lost
  end
end

module TryWinnable
  def choose(game_history, _)
    loop do
      self.move = Move.new(Move::VALUES.sample)
      # Keep this move unless computer win history contains at least 5 moves
      break unless analyze_wins(game_history).size > 5
      # If the win history has at least 6 moves, then keep current move if
      # it has already won at least twice; otherwise re-pick
      break if analyze_wins(game_history).count(move.to_s) > 1
    end
  end
end

module AvoidLosable
  def choose(game_history, human)
    loop do
      self.move = Move.new(Move::VALUES.sample)
      # Keep this move unless computer win history contains at least 5 moves
      break unless analyze_losses(game_history, human).size > 5
      # If the loss history has at least 6 moves, then discard current move
      # if it has lost more than once
      break unless analyze_losses(game_history, human).count(move.to_s) > 1
    end
  end
end

module Unpredictable
  def choose(_, _)
    # Computer chooses a random move:
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Hal < Computer
  # Avoids losing moves
  include AvoidLosable

  def set_name
    self.name = 'Hal'
  end

  def playing_style
    "learns to avoid re-picking\n" \
    "its losing moves from previous rounds."
  end
end

class Chappie < Computer
  # Tries to play the same moves that won before when possible
  include TryWinnable

  def set_name
    self.name = 'Chappie'
  end

  def playing_style
    "keeps an eye on which moves\n" \
    "seem to beat you more often, and repeats them."
  end
end

class R2D2 < Computer
  # Tries to play the same moves that won before when possible
  include TryWinnable

  def set_name
    self.name = 'R2D2'
  end

  def playing_style
    "keeps an eye on which moves\n" \
    "seem to beat you more often, and repeats them."
  end
end

class Sonny < Computer
  # Avoids losing moves
  include AvoidLosable

  def set_name
    self.name = 'Sonny'
  end

  def playing_style
    "learns to avoid re-picking\n" \
    "its losing moves from previous rounds."
  end
end

class Number5 < Computer
  # Plays totally random moves
  include Unpredictable

  def set_name
    self.name = 'Number 5'
  end

  def playing_style
    "picks moves according to its own\n" \
    "inscrutable internal logic - its " \
    "moves are impossible to predict!"
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
    wins >= 10
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
    generate_computer_opponent
    self.human_score = Score.new
    self.comp_score = Score.new
    self.game_data = GameHistory.new
  end

  def generate_computer_opponent
    self.computer = case rand(1..5)
                    when 1
                      R2D2.new
                    when 2
                      Hal.new
                    when 3
                      Chappie.new
                    when 4
                      Sonny.new
                    else
                      Number5.new
                    end
  end

  def play
    display_welcome_message
    loop do
      main_gameloop
      reset_score
      break unless new_game_same_players?
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
      puts "Your opponent today is #{computer.name} - it" \
      " #{computer.playing_style}"
      puts ""
      puts "The first player to win 10 rounds wins the whole game!"
      puts
      puts "Press ENTER when you're ready to play!"
      input = gets.chomp
      break if input
    end
  end

  def main_gameloop
    loop do
      main_gameplay
      game_data.increment_game_number
      if player_has_ten_wins?
        display_overall_winner
        break
      end
      break unless play_again?
    end
  end

  def main_gameplay
    players_choose
    record_winner
    game_data.update(human.move, computer.move, @round_winner)
    display_game_results
    display_wins
  end

  def players_choose
    system 'clear'
    human.choose
    computer.choose(game_data.history, human)
  end

  def record_winner
    human_move = human.move
    computer_move = computer.move

    if human_move > computer_move
      human_score.add_win
      self.round_winner = human.name
    elsif human_move < computer_move
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
    puts "#{round_winner} won!"
  end

  def display_wins
    puts ""
    puts "*** Score ***"
    puts "#{human.name}: #{human_score.wins}"
    puts "#{computer.name}: #{comp_score.wins}"
    puts ""
    puts "Total rounds played: #{game_data.game_number}"
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
  end

  def new_game_same_players?
    answer = nil
    loop do
      puts ""
      puts "Would you like to reset the Game Score, and \n" \
      "start a new game with the same players? (y/n)"
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
        print_history
      end

      break
    end
  end

  def print_history
    puts ""
    game_data.history.each do |round, data|
      puts "Round #{round}. #{computer.name}: #{data[:computer]} " \
                        " #{human.name}: #{data[:human]} " \
                        " #{data[:winner]} won!"
    end
  end
end

RPSGame.new.play

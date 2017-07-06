# RPS Bonus features 1a - in this version, the score is kept using instance
# variables in the RPSgame class. When a new game is created, the human
# and computer scores are initialized to zero, then these states are tracked
# as long as the game is played until someone reaches 10. 

# This certainly works as intended, but it requires 5 new instance methods to exist in the
# RPS game class. It also seems to go against the OOP idea that nouns should be 
# classes - "human score" and "computer score" are obviously nouns

require 'pry'

class Move
  VALUES = ['rock', 'paper', 'scissors']

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

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
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
      puts "Please choose rock, paper, or scissors:"
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

class RPSGame
  attr_accessor :human, :computer, :human_wins, :comp_wins

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_wins = 0
    @comp_wins = 0
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper Scissors. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def add_human_win
    @human_wins += 1
  end

  def add_comp_win
    @comp_wins += 1
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      add_human_win
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      add_comp_win
    else
      puts "It's a tie!"
    end
  end

  def display_wins
    puts "#{human.name} has #{@human_wins} wins."
    puts "#{computer.name} has #{@comp_wins} wins."
  end

  def overall_winner?(player_wins, comp_wins)
    player_wins >= 10 || comp_wins >= 10
  end

  def display_overall_winner
    puts "#{human.name} is the overall winner!" if @human_wins >= 10
    puts "#{computer.name} is the overall winner!" if @comp_wins >= 10
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_wins
      if overall_winner?(@human_wins, @comp_wins)
        display_overall_winner
        break
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play

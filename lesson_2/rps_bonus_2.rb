require 'pry'

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
    @wins += 1
  end

  def winning_score?
    @wins >= 10
  end
end

class RPSGame
  attr_accessor :human, :computer, :human_wins, :comp_wins

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_wins = Score.new
    @comp_wins = Score.new
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

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human_wins.add_win
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      comp_wins.add_win
    else
      puts "It's a tie!"
    end
  end

  def display_wins
    puts "#{human.name} has #{human_wins.wins} wins."
    puts "#{computer.name} has #{comp_wins.wins} wins."
  end

  def display_overall_winner
    puts "#{human.name} is the overall winner!" if human_wins.winning_score?
    puts "#{computer.name} is the overall winner!" if comp_wins.winning_score?
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
      if human_wins.winning_score? || comp_wins.winning_score?
        display_overall_winner
        break
      end
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play

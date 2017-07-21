class GuessingGame
  attr_accessor :guesses
  attr_reader :number

  #def initialize
  #  @guesses = 7
  #  @number = rand(1..100)
  #end

  def play
    reset
    guess = nil
    while guesses > 0
      puts "You have #{guesses} guesses remaining."
      loop do
        puts "Enter a number between 1 and 100:"
        guess = gets.chomp.to_i
        break if (1..100).cover?(guess)
        puts "Invalid guess"
      end
      if guess < number
        puts "Your guess is too low"
        minus_one
      elsif guess > number 
        puts "Your guess is too high"
        minus_one
      else
        puts "You win!"
        break
      end
    end
  end

  def minus_one
    @guesses -= 1
  end

  def reset
    @guesses = 7
    @number = rand(1..100)
  end

end

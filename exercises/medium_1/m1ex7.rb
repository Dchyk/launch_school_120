class GuessingGame
  attr_accessor :guesses
  attr_reader :number, :upper, :lower, :size_of_range

  def initialize(lower, upper)
    @lower = lower
    @upper = upper
    @size_of_range = (lower..upper).size
  end

  def play
    reset
    guess = nil
    while guesses > 0
      puts "You have #{guesses} guesses remaining."
      loop do
        puts "Enter a number between #{lower} and #{upper}:"
        guess = gets.chomp.to_i
        break if (lower..upper).cover?(guess)
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
    @guesses = Math.log2(size_of_range).to_i + 1
    @number = rand(lower..upper)
  end

end

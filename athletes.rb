class Athlete
  attr_reader :name, :age, :weight

  def initialize(name, age, weight)
    @name = name
    @age = age
    @weight = weight
  end

  def run
    puts "Runs!"
  end

  def jump
    puts "Jumps!"
  end

  def to_s
    "#{name} is a #{age} year old #{self.class} who weighs #{weight} lbs."
  end
end

class BallPlayer < Athlete
  def throw
    "Throws the ball"
  end
end

module Dribblable
  def dribble
    "Dribbles the ball"
  end
end

module Kickable
  def kick
    "Kicks the ball"
  end
end

class BasketballPlayer < BallPlayer
  attr_reader :points, :rebounds

  include Dribblable

  def initialize(name, age, weight, points, rebounds)
    super(name, age, weight)
    @points = points
    @rebounds = rebounds
  end

  def to_s
    super
    "#{name} has #{points} and #{rebounds} rebounds this season."
  end
end

class BaseballPlayer < BallPlayer

  def initialize(name, age, weight, rbis)
    super(name, age, weight)
    @rbis = rbis
  end

  def hit
    puts "Hits the ball into play!"
  end
end

class FootballPlayer < BallPlayer
  include Kickable

  def initialize(name, age, weight, yards)
    super(name, age, weight)
    @yards = yards
  end
end

class SoccerPlayer < BallPlayer
  include Dribblable
  include Kickable

  def initialize(name, age, weight, goals)
    super(name, age, weight)
    @goals = goals
  end
end

class Runner < Athlete
  def initialize(name, age, weight, range)
    super(name, age, weight)
    @range = range
  end
end


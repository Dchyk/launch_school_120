class Cat 
  COLOR = 'purple'

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def greet
    puts "Hello! My name is #{name} and I'm a #{COLOR} cat!"
  end

  def to_s
    "I'm #{name}!"
  end
end


kitty = Cat.new('Sophie')
kitty.greet
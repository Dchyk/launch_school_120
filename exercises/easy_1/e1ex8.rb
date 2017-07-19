class Pet
  attr_reader :name, :age, :fur_type

  def initialize(name, age, fur_type)
    @name = name
    @age = age
    @fur_type = fur_type
  end
end

class Cat < Pet
  def to_s
    "My cat #{name} is #{age} years old and has #{fur_type} fur."
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch
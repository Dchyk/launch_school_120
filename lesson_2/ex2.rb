class Person 
  attr_accessor :first_name, :last_name

  def initialize(name)
    @first_name = name
    @last_name = ''
  end

  def name
    @first_name + ' ' + @last_name
  end

end

bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'
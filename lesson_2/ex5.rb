class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name= (full_name)
    arse_full_name(full_name)
  end

  def to_s
    name 
  end

  private

  def parse_full_name(full_name)
    @first_name, @last_name = full_name.split
    @last_name = '' if @last_name == nil
  end

end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}" #=> "The person's name is Robert Smith"
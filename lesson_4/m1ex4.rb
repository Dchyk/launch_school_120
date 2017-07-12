class Greeting
  def greeting(str)
    puts str
  end
end

class Hello < Greeting
  def hi
    greeting("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greeting("Goodbye")
  end
end
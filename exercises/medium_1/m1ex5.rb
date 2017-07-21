class Minilang
  attr_accessor :stack, :register
  attr_reader :commands

  def initialize(string)
    @stack    = []
    @register = 0
    @commands = string.split(' ')
  end

  def eval
    @commands.each do |command|
        if command.to_i.to_s == command          
          self.send :store_in_register, command
        elsif self.methods.include?(command.downcase.to_sym)
          self.send command.downcase.to_sym
        else
          puts "Invalid token!"
        end
    end

  end

  def store_in_register(command)
    self.register = command.to_i
  end

  def push
    self.stack << register
  end

  def add
    self.register = register + stack.pop
  end

  def sub
    self.register = register - stack.pop
  end

  def mult
    self.register = register * stack.pop
  end

  def div
    self.register = register / stack.pop
  end

  def mod
    self.register = register % stack.pop
  end

  def pop
    if stack.empty?
      puts "Empty stack!"
    else
      self.register = stack.pop
    end
  end

  def print
    puts register
  end
end
class Transform
  def initialize(string)
    @string = string
  end

  def uppercase
    @string.upcase 
  end

  def self.lowercase(string)
    string.downcase
  end

end
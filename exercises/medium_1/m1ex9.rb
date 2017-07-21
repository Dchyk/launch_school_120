class Deck
  RANKS = (2..10).to_a + %w(Jack Queen King Ace).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :deck

  def initialize
    @deck = create_new
  end

  def create_new
    deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def draw
    reset if self.size <= 0
    deck.shuffle!
    deck.pop
  end

  def size
    deck.size
  end

  def ==(other_deck)
    self == other_deck # uses Array == method
  end

  def reset
    @deck = create_new
  end

end



class Card
  VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 
                  7 => 7, 8 => 8, 9 => 9, 10 => 10,
                  'Jack' => 11, 'Queen' => 12, 'King' => 13,
                  'Ace' => 14 }

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    VALUES[rank]
  end

  def <=>(other_card)
    self.value <=> other_card.value
  end

  def ==(other_card)
    self.value == other_card.value
  end

  def min
    self.sort_by { |card| card.value }
  end

  def max
    self.max_by { |card| card.value }
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

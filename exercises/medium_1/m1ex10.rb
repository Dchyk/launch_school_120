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

  def pop
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
  ROYALS = ['Jack', 'Queen', 'King', 'Ace', 10]

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

class PokerHand
  attr_reader :hand

  def initialize(cards)
    @hand = []
    if cards.class == Deck
      5.times { @hand << cards.draw }
    else
      5.times { @hand << cards.pop }
    end
  end

  def print
    hand.each { |card| puts card }
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush? # Works
    hand.select { |card| Card::ROYALS.include?(card.rank) }.size == 5
  end

  def straight_flush? # Works 
    flush? && straight?
  end

  def four_of_a_kind? # Works
    hand.any? do |card|
      hand.collect(&:rank).count(card.rank) == 4
    end
  end

  def full_house? # Works
    pair? && three_of_a_kind?
  end

  def flush? # Works
    hand.any? do |card|
      hand.collect(&:suit).count(card.suit) == 5
    end
  end

  def straight? # Works - using each_con
    hand.sort_by { |card| card.value }.each_cons(2).all? { |x,y| y.value == x.value + 1 }
  end

  def three_of_a_kind? # Works
    hand.any? do |card|
      hand.collect(&:rank).count(card.rank) == 3
    end
  end

  def two_pair? # Works
    counts = Hash.new(0)
    
    hand.each do |card|
      counts[card.rank] += 1
    end

    return true if counts.values.select { |value| value == 2 }.size == 2
  end

  def pair? # Works
    hand.any? do |card|
      hand.collect(&:rank).count(card.rank) == 2
    end
  end
end
class Participant
  # What goes here? All redundant behaviors from Player and Dealer?
  attr_accessor :cards

  def initialize(cards)
    # What would a "data" or "states" of a Player object entail
    # cards, name, score
    @cards = cards
  end

  def stay
  end

  def busted?
    @cards > 21
  end

  def total
    # seems like we'll need to know about "cards" to calculate this
  end

end

class Player < Participant

  def hit
    # Choose whether to hit or stay
  end

end

class Dealer
  
  def deal
    # does the dealer deal, or does the deck deal?
  end

  def hit
    # hits up to 17
  end

end


class Deck
  
  def initialize
    # Needs some data structure to hold the deck
    # An array of card objects?
    # Used an array in the procedural version (because suit doesn't matter?)
  end

  

  def deal_first_hand
    # Does dealer deal, or does deck deal?
    2.times do
      player.cards += deck.deal_a_card
      dealer.cards += deck.deal_a_card
    end
  end
end

class Card
  SUITS = ['C', 'D', 'H', 'S']
  FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(suit, face)
    # What are the "states" of a card?
    @suit = suit
    @face = face
  end

  def to_s
  end


end

module Hand
  def show
    # display self.cards 
  end

  def cards
    @cards
  end

  def >(other_hand)
    cards.determine_total > other_hand.cards.determine_total
  end

  def <(other_hand)
    cards.determine_total < other_hand.cards.determine_total
  end

  def determine_total
    # Add up the cards in the hand
    # Adjust for Aces
    # Return the integer value of the total
  end

end

class Game
  def initialize
    @dealer = Dealer.new
    @player = Player.new
    @deck = Deck.new
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end

  def deal_cards
    deck.deal_first_hand
  end

  def show_initial_cards
    player.cards.show
    dealer.cards.show
  end

  def player_turn
    # loop 
    # IF you want to hit, 
    player.hit
    # break if not or if 
    player.busted?
  end

  def dealer_turn
    dealer.hit # up to 17
    # break if 
    dealer.busted? || dealer.hand >= 17
  end

  def show_result
    puts "score:"
    if player.hand > dealer.hand 
      puts "Player won!"
    elsif dealer.hand > player.hand
      puts "Dealer won!"
    else 
      puts "It's a tie!"
    end
  end
end

Game.new.start
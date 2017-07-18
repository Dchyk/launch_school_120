require 'pry'

module Hand
  WINNING_HAND = 21

  def >(other_player)
    hand_total > other_player.hand_total
  end

  def <(other_player)
    hand_total < other_player.hand_total
  end

  def hand_total
    total = 0
    @cards.each do |card|
      total += card.value
      total -= 10 if total > WINNING_HAND && card.face == 'A' # adjust for Aces
    end

    total
  end

  def busted?
    hand_total > WINNING_HAND
  end
end

class Participant
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def display_cards
    cards = []
    @cards.each do |card|
      cards << "#{card.face} of #{card.suit}"
    end
    cards.join(', ')
  end

  def reset
    @cards = []
  end
end

class Player < Participant
  include Hand

  def hit(deck)
    @cards << deck.deal_card
  end
end

class Dealer < Participant
  include Hand

  # Dealer will keep hitting until its hand is at least 17
  def hit(deck)
    loop do
      break if hand_total >= 17
      @cards << deck.deal_card
    end
  end

  def display_flop
    "#{cards.first.face} of #{cards.first.suit}, ??"
  end
end

class Deck
  def initialize
    @deck = create_new_deck
  end

  def create_new_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        deck << Card.new(suit, face)
      end
    end
    deck
  end

  def shuffle!
    @deck.shuffle!
  end

  def deal_card
    @deck.pop
  end
end

class Card
  CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
                  '8' => 8, '9' => 9, '10' => 10, 'J' => 10,  'Q' => 10,
                  'K' => 10, 'A' => 11 }
  SUITS = ['C', 'D', 'H', 'S']
  FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  attr_reader :suit, :face

  def initialize(suit, face)
    # What are the "states" of a card?
    @suit = suit
    @face = face
  end

  def to_s
    "#{@face} of #{@suit}"
  end

  def value
    CARD_VALUES[face]
  end
end

class Game
  attr_reader :deck, :dealer, :player

  def initialize
    @dealer = Dealer.new
    @player = Player.new
    @deck = Deck.new
  end

  def start
    loop do
      display_welcome_message
      shuffle_deck
      deal_cards
      show_flop
      player_turn
      dealer_turn unless player.busted?
      show_all_cards
      show_result
      break unless play_again?
      reset_game
    end
    display_goodbye_message
  end

  def shuffle_deck
    deck.shuffle!
  end

  def deal_cards
    2.times do
      dealer.cards << deck.deal_card
      player.cards << deck.deal_card
    end
  end

  def show_all_cards
    puts "Dealer flips over his table card..."
    puts ""
    puts "Dealer has: #{dealer.display_cards}. Total score: " \
    "#{dealer.hand_total}"
    show_player_cards
  end

  def show_flop
    puts "Dealer has: #{dealer.display_flop}. Total score: ??"
    show_player_cards
  end

  def show_player_cards
    puts "Player has: #{player.display_cards}. Total score: " \
    "#{player.hand_total}"
    puts ""
  end

  def player_turn
    input = nil
    loop do
      break if player.busted?
      puts "Do you want to hit or stay? Any key to hit, or type (s) to (s)tay:"
      input = gets.chomp
      break if input.start_with?('s') || player.busted?
      player.hit(deck)
      system 'clear'
      show_flop
    end
  end

  def dealer_turn
    system 'clear'
    puts "Dealer hits..."
    puts ""
    dealer.hit(deck)
  end

  def show_result
    if player.busted?
      puts "You busted! Dealer wins!"
    elsif dealer.busted?
      puts "Dealer busted! You win!"
    elsif player > dealer
      puts "Player wins!"
    elsif dealer > player
      puts "Dealer wins!"
    else
      puts "It's a tie!"
    end
  end

  def busted_message
    puts "You busted! game over, dealer wins!"
  end

  def display_welcome_message
    system 'clear'
    puts "Hello and welcome to 21!"
    puts ""
  end

  def play_again?
    input = nil
    loop do
      puts ""
      puts "Do you want to play again? (y/n)"
      input = gets.chomp
      break if %w[y n].include?(input)
      puts "I don't understand - please type (y) or (n)"
    end

    return true if input == 'y'
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Twentyone - I enjoyed taking your money! Bye!"
  end

  def reset_game
    player.reset
    dealer.reset
    @deck = Deck.new
  end
end

Game.new.start

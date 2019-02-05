require_relative 'card' 


class Deck
  attr_accessor :deck
  # Returns an array of all 52 playing cards.
  def self.all_cards
    cards = []
    Card.suits.each do |suit|
      Card.values.each do |value|
        cards << Card.new(suit, value)
      end
    end

    cards.shuffle
    #shuffles the cards array. not needed for tests but needed for a functional game
  end

  def initialize(cards = Deck.all_cards)
    @deck = cards
  end

  # deals 26 cards to the player that is passed as an argument
  def deal(player)
    cards = []
    26.times do 
      cards << self.deck.shift
    end

    player.receive_cards(cards)
  end

  # Returns an array of cards to the bottom of the deck (back of the cards array).
  def return(new_cards)

    new_cards.each do |card|
      self.deck.push(card)
    end

  end
end

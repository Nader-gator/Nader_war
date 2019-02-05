class Player

  attr_accessor :packet, :hand
  #packet is the cards player has, hand is the cards player has played againt opponent
  def initialize 
    @packet = []
    @hand = []
  
  end
  #add cards to the bottom of hand
  def receive_cards(cards)
    

    raise "no cards were given to me" if cards.empty?
    cards.each do |card|
      self.packet.unshift(card)
    end

  end

  #adds own hand to packet
  def take_own_hand 
    self.receive_cards(self.hand)
    self.hand = []
  end

  #when lost the play, this method gives hand and resets it to an empty array
  def give_hand
    
    lost = []

    self.hand.each do |card|
      lost << card
    end


    self.hand = []
    lost
  end 

  #moves a card from packet to hand
  def play
    self.hand << self.packet.pop
  end
  #returns the point value of last played card (last card in hand)
  def points
    self.hand.last.point
  end
  #creturn count of cards in packet, nil if no cards
  def count
    return nil if self.packet.count == 0
    self.packet.count
  end

end
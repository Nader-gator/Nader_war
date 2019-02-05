require 'rspec'
require 'player'
require 'card'
describe Player do
  let(:player) {Player.new}
  let(:cards) do
    cards = [
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack)]
  end

  let(:cards2) do
    cards = [
      Card.new(:hearts, :king),
      Card.new(:hearts, :queen),
      Card.new(:hearts, :jack)
    ]
  end

  describe "#initialize" do 
    it "starts with an empty packet" do 
      expect(player.packet).to be_empty
    end

    it "starts with an empty hand" do 
      expect(player.hand).to be_empty
    end  
  end

  describe "#count" do 
    it "returns the correct card count" do 
      player.packet = [1,2,3]
      expect(player.count).to eq(3)
    end

    it "returns nil when hand is empty" do 
      expect(player.count).to be_nil
    end


  end

  describe "#receive_cards" do 

    it "receives cards" do 
      player.receive_cards(cards) 
      expect(player.count).to eq(3)
    end

    it "throws error if no cards are given" do 
      expect{player.receive_cards([])}.to raise_error("no cards were given to me")
    end
  
    it "puts the cards at the bottom of the packet" do 
      player.receive_cards(cards)
      player.receive_cards(cards2)
      cards3 = (cards2.reverse).concat(cards.reverse)
      expect(player.packet).to eq(cards3)
    end
  
    it "deos not modify the array passes to it" do 
      card_dup = cards.dup
      player.receive_cards(card_dup)
      expect(card_dup).to eq(cards)
    end
    
  
  end 

  describe "#take_own_hand" do 
    it "calls on recieve cards for own hand" do 
      player.hand = [1,2,3,4]
      expect(player).to receive(:receive_cards).with(player.hand)
      player.take_own_hand
    end
    it "sets own hand as nil" do 
      player.hand = [1,2,3,4]
      player.take_own_hand
      expect(player.hand).to be_empty
    end
  end
  
  describe "#give_hand" do   
    it "gives and empty array if hand is empty" do 
      lost_hand = player.give_hand
      expect(lost_hand).to eq([])
    end
    it "gives all the cards in players hand" do 
      player.hand = [1]
      lost_hand = player.give_hand
      expect(lost_hand).to eq([1])
    end
    it "sets the players hand to an empty array" do 
      player.hand = [1,2,3,4,5]
      player.give_hand
      expect(player.hand).to be_empty
    end
    it "gives lost cards in the same order as hand" do 
      player.hand = [1,2,3,4,5]
      lost_hand = player.give_hand
      expect(lost_hand).to eq([1,2,3,4,5])
    end
  end 
  
  describe "#play" do 
    before do player.packet = [1,2,3,4,5]
    end
    
    it "inserts the card into the hand" do 
     player.play
     expect(player.hand).to_not be_empty
    end
    it "takes the played card out of packet" do 
      player.play
      expect(player.packet.count).to eq(4)
    end
    it "adds the played card to the top of the hand (last element of array)" do
      player.play
      expect(player.hand).to eq([5])
    end

  end

  describe "#points" do 
    let(:card3) {double("card3")}
    it "returns the point value of the last played card" do 
      player.hand = [1, 2, card3]
      allow(card3).to receive(:point).and_return(10)
      expect(player.points).to eq(10)
    end
  end
      
  
  
end
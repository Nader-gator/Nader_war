require 'rspec'
require 'deck'

describe Deck do
  describe '::all_cards' do
    subject(:all_cards) { Deck.all_cards }

    it { expect(all_cards.count).to eq(52) }

    it 'returns all cards without duplicates' do
      deduped_cards = all_cards
        .map { |card| [card.suit, card.value] }
        .uniq
        .count
      expect(deduped_cards).to eq(52)
    end
  end

  let(:cards) do
    cards = [
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack)
    ]
  end

  describe '#initialize' do
    it 'by default fills itself with 52 cards' do
      maindeck = Deck.new
      expect(maindeck.deck.count).to eq(52)
    end

    it 'can be initialized with an array of cards' do
      maindeck = Deck.new(cards)
      expect(maindeck.deck.count).to eq(3)
    end

  end

  let(:deck) do
    Deck.new(cards.dup)
  end

  it 'does not expose its cards directly' do
    expect(deck).not_to respond_to(:cards)
  end

  describe '#deal' do
    subject(:deck) {Deck.new}
    let(:player) { double("player") }

    it "calls player to recieve cards" do 
      expect(player).to receive(:receive_cards).with(anything)
      deck.deal(player)
    end

    it "deals 26 cards" do 
      expect(player).to receive(:receive_cards) do |card_deck|
        expect(card_deck.count).to eq(26)
      end
      deck.deal(player)
    end
    
    it "removes cards that are dealt" do 
      expect(player).to receive(:receive_cards)
      deck.deal(player)
      expect(deck.deck.count).to eq(26)
    end
    it "does not hand duplicate cards" do
      expect(player).to receive(:receive_cards) do |card_deck|
        expect(card_deck).to eq(card_deck.uniq)
      end
      deck.deal(player)
    end
    
  end

  describe "#return" do
    let(:player) { double("player") }
    let(:deck) {Deck.new}
    let(:return_cards) do 
      [Card.new(:hearts, :four),
       Card.new(:hearts, :five),
       Card.new(:hearts, :six)]
    end
    it "returns cards to the deck"  do 
      allow(player).to receive(:receive_cards)
      deck.deal(player)
      deck.return(return_cards)
      expect(deck.deck.count).to eq(29)
    end
    it "deosn't destroy the passed array" do 
      the_dup = return_cards.dup
      deck.return(the_dup)
      expect(the_dup).to eq(return_cards)
    end
  
  end 
  

end

require 'rspec'
require 'game'
require 'byebug'
describe Game do
  let(:game) {Game.new}
  describe "#initialize" do 

    
    it "starts a new game with two players" do 
      expect(game.player1)
      expect(game.player2)
    end
    it "each player is a player class" do 
      expect(game.player1).to be_a(Player)
      expect(game.player2).to be_a(Player)
    end
    it "starts the game with an instance of deck" do
      expect(game.deck).to be_a(Deck)
    end

  end


  describe "#deal" do 
    it "calls #deal on deck twice, once for each player" do
      expect(game.deck).to receive(:deal)
      expect(game.deck).to receive(:deal)
      game.deal
    end
    it "passes the player to #deal" do 
      expect(game.deck).to receive(:deal).with(game.player1)
      expect(game.deck).to receive(:deal).with(game.player2)
      game.deal
    end
  end


  describe "#winner?" do
    let(:player1) {double("player1")}
    let(:player2) {double("player2")}
    it "returns the player instance who is the winner" do 
      allow(player1).to receive(:points).and_return(10)
      allow(player2).to receive(:points).and_return(5)
      
      winner = game.winner?(player1,player2)  

      expect(winner).to eq(player1)
    end

    it "calls #points on each player" do 
      expect(player1).to receive(:points).at_least(:once).and_return(10)
      expect(player2).to receive(:points).at_least(:once).and_return(5)
      game.winner?(player1,player2)
    end

    it "returns nil if there is no winners" do
      allow(player1).to receive(:points).and_return(10)
      allow(player2).to receive(:points).and_return(10)
      winner = game.winner?(player1,player2)  

      expect(winner).to be_nil
    end
  end



  describe "#give_cards_to_winner" do
    let(:winner) {double("winner")}
    let(:loser) {double("loser")}
    it "gives cards to the winner" do 
      allow(loser).to receive(:give_hand).and_return([1,2,3])
      expect(winner).to receive(:receive_cards).with([1,2,3])
      game.give_cards_to_winner(winner, loser)
    end
    it "takes the losers hand" do 
      allow(winner).to receive(:receive_cards)
      expect(loser).to receive(:give_hand)
      game.give_cards_to_winner(winner, loser)
    end
  end
  
  


  describe "#handle_winner" do 
    let(:winner) {double("winner")}
    let(:loser) {double("loser")}

    it "calls #give_cards_to_winner" do 
      expect(game).to receive(:give_cards_to_winner)
      allow(game).to receive(:winner?).with(winner,loser).and_return(winner)
      allow(winner).to receive(:take_own_hand)
      game.handle_winner(winner,loser)
    end
      
    it "calls #give_cards_to_winner with the correct winner and loser" do 
      expect(game).to receive(:give_cards_to_winner).with(winner,loser)
      allow(game).to receive(:winner?).with(winner,loser).and_return(winner)
      allow(winner).to receive(:take_own_hand)
      game.handle_winner(winner,loser)
    end
  end



  describe "play_hand" do 
    let(:player1) {double("player1")}
    let(:player2) {double("player2")}
    it "calls #play on each player" do 
      expect(game.player1).to receive(:play)
      expect(game.player2).to receive(:play)
      allow(game).to receive(:winner?).and_return(player1)
      game.play_hand
    end

    it "calls winner?" do
      expect(game).to receive(:winner?).and_return(player1).at_least(:once)
      game.play_hand
    end

    let(:winner) {double("winner")}
    let(:loser) {double("loser")}

    it "if there is a winner, calls on #handle_winner" do 
      expect(game).to receive(:handle_winner).with(game.player1, game.player2)
      allow(game).to receive(:winner?).and_return(true)
      game.play_hand
    end
    it "calls on #war if there is no winner" do 
      allow(game).to receive(:winner?).and_return(nil)
      expect(game).to receive(:war)
      game.play_hand
    end
  end
  

  describe "#war" do 
    let(:player1) {double("player1")}
    let(:player2) {double("player2")}
    it "calls play on each player" do
      expect(game.player1).to receive(:play).at_least(:once)
      expect(game.player2).to receive(:play).at_least(:once)
      allow(game).to receive(:winner?).and_return(false, true)
      allow(game).to receive(:handle_winner)
      game.war
    end
    it "loops until there is a winner, using #winner? boolean" do 
      expect(game.player1).to receive(:play).at_least(:twice)
      expect(game.player2).to receive(:play).at_least(:twice)
      allow(game).to receive(:winner?).and_return(false,false, true)
      allow(game).to receive(:handle_winner)
      game.war
    end
    it 'calls on #handle winner' do 
      allow(game).to receive(:winner?).and_return(true)
      expect(game).to receive(:handle_winner)
      game.war
    end

  end


  
  
end
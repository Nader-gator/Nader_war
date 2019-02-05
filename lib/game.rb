require_relative 'deck'
require_relative 'player'

class Game
  attr_reader :player1, :player2, :deck
  #initialize with two instances of player and one instance of deck
  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @deck = Deck.new
  end
  #deals cards to each player
  def deal
    self.deck.deal(player1)
    self.deck.deal(player2)
  end 
  #takes two player instances as argument and retutns the player instance that has the winning hand
  def winner?(p1, p2)
    if p1.points > p2.points 
      return p1
    elsif p1.points < p2.points 
      return p2
    else 
      return nil
    end
  end 

  #takes a winner and loser player instance and takes cards from the loser and gives it to the winner
  def give_cards_to_winner(winner, loser)
    lost_cards = loser.give_hand
    winner.receive_cards(lost_cards)
  end


  #determines who the winner is by calling #winner and calls #give_cards_to_winner, and calls take_own_hand on winner
  def handle_winner(p1,p2)
    winner = winner?(p1,p2)
     if winner == p1
      give_cards_to_winner(p1, p2)
      p1.take_own_hand
    elsif winner == p2
      give_cards_to_winner(p2, p1)
      p2.take_own_hand
    end
  end



  #each player plays a hand, if there is a winner #handle_winner is called, if thre is a war, #war is called
  def play_hand

    p1 = self.player1
    p2 = self.player2
    p1.play
    p2.play
    winner = winner?(p1,p2)
    if winner
      handle_winner(p1,p2)
    else 
      self.war
    end

  end

  

  #loops until there is a winner and then calls #handle_winner
  def war
    
    until winner?(self.player1,self.player2)
      4.times do 
        player1.play
        player2.play
      end
    end

    handle_winner(self.player1,self.player2)

  end



  #not needed for testing, it plays the game until someone wins
  def play_the_game
    self.deal
    while player1.count && player2.count
      self.play_hand
    end

    p player1.packet
    p player2.packet

  end
  


end
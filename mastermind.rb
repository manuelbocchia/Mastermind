# symbols are these: ['< $ > < & > < # > < ? > < ! > < % >'] 
# the beads module is important for generating the random code, and for having the UI strings for the game.
# random_beads method returns a string with the beads


module Beads
  BEADS = '< $ > < & > < # > < ? > < ! > < % >'
  SYMBOLS = ["$","&","#","?","!","%"]
  def symbols
    SYMBOLS
  end
  def random_beads
    rd_beads_arr = []
    4.times do
      rd_beads_arr.push(SYMBOLS[rand(0..5)])
    end
    rd_beads_arr.join("")
  end
end

# The game class creates the game object with players and their scores. It's methods include the rounds and the guess builder. The round calls the guess builder 12 times, and stops if the guess is true. That should update the player score with the number of rounds.

class Game
  include Beads
  @@round = 0
  @@round_hash = {}
  def initialize(player1 = "USER",player2 = "BOT")
    @player1 = player1
    @player1_score = 0
    @player2 = player2
    @player2_score = 0
  end
  def set_name
    @game_type = gets.chomp
      if @game_type =~ /man/i
        puts "Enter player 1 name:"
        @player1 = gets.chomp
        puts "Enter player 2 name:"
        @player2 = gets.chomp
      elsif @game_type =~ /bot/i 
        puts "Enter player 1 name:"
        @player1 = gets.chomp
      end
  end
  def play
    puts "\n Welcome to Mastermind. The game where you need to crack the secret code."
    puts "\n You can choose to play head to head against a fellow human..."
    puts "\n ...or face humanity's greatest foe of their own creation: the computer."
    puts "\n What will it be? Choose MAN or BOT"
    set_name
    if @game_type =~ /bot/i
      loop do
        self.game_BOT
        puts "\n Your score is: #{@player1_score}."
        puts "\n Give it another go? Y/N"
        break if gets.chomp =~ /y/i
        end
    elsif @game_type =~ /man/i
      self.game_PVP
    end
  end
  def build_guess
    puts "\n Enter your guess:"
    loop do
    @@guess = gets.chomp
      if @@guess.split("").all?(/[#$%&?!]/) && @@guess.length == 4
      puts "This is your guess:"
      puts @@guess
      puts "\n Try it out? Y/N"
      answer = gets.chomp
        if answer =~ /y/i
          break
        else puts "\n Enter your guess again:"
        end
      else puts "\n Wrong input, try again:"
      end
    end
  end
  def game_BOT
    @@new_game = SecretCode.new(self.random_beads)
    puts "\n #{@player1}, you must find the bot's secret code."
    until @@round == 11
      round
    end
  end
  def game_PVP
    puts "\n It's your turn, Mastermind. Choose the code."
    @@new_game = SecretCode.new(gets.chomp)
  end
  def round
    @@round += 1
    puts "\n Write a four digit code using the ancient symbols:"
    puts "\n #{Beads::BEADS}"
    puts "\n You've played: #{@@round_hash.to_a.flatten}" if @@round > 1
    build_guess
    @@round_hash[@@round] = [@@guess, @@new_game.hints(@@guess)]
      if @@new_game.matches_code?(@@guess) == true
        puts "\n Congratulations! You've cracked the code in #{@@round} rounds!"
        @player1_score += (13 - @@round)
      elsif @@round == 12 
        puts "\n You've failed to crack the code. You lose."
      end
  end
end

# the secret code class creates the secret code and has the #matches_code? method, which returns either true or a set of hints.

class SecretCode
  attr_reader :code, :code_arr, :code_hash
  include Beads
  def initialize(string)
    @code = string
    @code_arr = string.split("")
  end
   
  def matches_code?(guess)
    if guess == @code
      true
    else
      puts hints(guess)
    end
  end
  def hints(guess)
    guess_arr = guess.split("")
    hint_arr = []
    guess_arr.each_with_index{ |char, index|
    if @code_arr[index] == char
      hint_arr.push("FULL")
    elsif @code_arr.any?(char)
      hint_arr.push("SYMB")
    else
      hint_arr.push("NONE")
    end
    }
    full = hint_arr.count("FULL")
    symb = hint_arr.count("SYMB")
    return "HINT: #{full} FULL | #{symb} SYMB."
  end
end

new_game = Game.new("Manu")

new_game.play
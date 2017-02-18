require 'json'

class Game
   @@dictionary = File.readlines "5desk.txt"
  attr_accessor :correct_letters, :incorrect_letters, :secret_word, :guesses, :dictionary
  correct_letters = []
  incorrect_letters = []
  secret_word = ""
  guesses = 0
  def self.get_secret_word
  secret_word = @@dictionary.select {|word| (5..12).include? word.chomp.length  }.sample.chomp
  end
  def initialize 
    @correct_letters = []  
    @incorrect_letters = []
    @secret_word =  Game.get_secret_word.downcase
    @guesses = 0
  end  

  def check_letter letter
    @secret_word.include?(letter) ? @correct_letters << letter : @incorrect_letters << letter
  end
  
  def display_result *args
    @secret_word.each_char {|l| @correct_letters.include?(l) ? print(l) : print( "_ ") }
  puts 
  puts
  puts "incorrect_letters: #{@incorrect_letters.join(",")}" if args.empty?
       puts
  end 
  
  def game_over?
    @secret_word.split("").all? {|l|  @correct_letters.include? l}
  end  
  
  def self.start_game game=Game.new
  
  puts "please enter a letter"
  puts "OR\ntype 'load' to load a previous game\nyou have #{7 - game.guesses} guesses left!"
  choice = gets.chomp

  if choice == "load"
  	puts "Please type type one of the games listed below:"

Dir.glob("./saved_games/*").each do |file|

puts file.match(/(^.*\/.*\/)(.*)/)[2]

end
old_game = gets.chomp
  game.load_game old_game
  game.display_result
  puts "you have #{7 - game.guesses} guesses left!"
else
	game.check_letter choice
	game.display_result
	game.guesses += 1

  end	

  
  while game.guesses < 7
  	
  guess= gets.downcase.chomp
  if guess == "save"
puts "please enter a name for saving:"
name = gets.chomp
game.save_game name
puts "Catch you later.."
return
  end	
  game.check_letter guess
  game.display_result
  game.guesses += 1
  if game.game_over?
  puts "Hooray"
  break
  end
    puts "please enter a letter\nyou have #{7 - game.guesses} guesses left!"
  puts "OR\n type 'save' to save the game"

  end
 puts "Oops! Word was: #{game.secret_word}" unless game.game_over?
  
  
  end  
  
  def save_game name
    
    x = JSON.dump({
      :correct_letters => @correct_letters,
      :incorrect_letters => @incorrect_letters,
      :guesses => @guesses,
      :secret_word => @secret_word
    })
    
  Dir.mkdir "saved_games" unless Dir.exists? "saved_games"
  
  File.open("./saved_games/#{name}","w") {|f| f.puts x}
    
  end  

  def load_game name 
game_hash = File.read("./saved_games/#{name}")
data = JSON.load(game_hash)
data.each { |k,v| self.instance_variable_set("@#{k}",v) }
 end	
  
end

Game.start_game

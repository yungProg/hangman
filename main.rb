require_relative 'lib/hangman'

game = Hangman.new
puts 'Welcome to Hangman'
if File.exist?('save.json')
  puts "Enter 's' to start new game or 'l' to load"
  new_game = gets.chomp.downcase
end

if new_game == 's'
  game.game
else
  game.load_state
  game.game
end
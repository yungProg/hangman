game_dictionary = File.readlines('google-10000-english-no-swears.txt')

def clean_game_dictionary(dic)
  dic.map! { |vocab| vocab.strip.downcase }
  dic.select! { |vocab| vocab.length > 4 && vocab.length < 13 }
end

def game
  clean_game_dictionary(game_dictionary)

  word = game_dictionary.sample
  word_arr = word.split('')

  incorrect_guess_remaining = 6
  incorrect_letters = []
  correct_guess = false

  guess = []
  word.length.times { guess.push('_ ') }
  puts 'Welcome to Hangman'

  puts '_ '*word.length

  loop do
    puts 'Enter guess'
    player_guess = gets.chomp.downcase

    frequency = word.count(player_guess)
    incorrect_letters.push(player_guess) unless frequency > 0 && incorrect_letters.include?(player_guess)
    puts "Incorrect guess remaining: #{incorrect_guess_remaining -= 1}" if frequency == 0
    puts incorrect_letters.inspect unless incorrect_letters.empty?

    frequency.times do |word_index|
      word_index = word_arr.index(player_guess)
      guess[word_index] = player_guess + ' '
      word_arr[word_index] = nil
    end

    puts guess.join
    correct_guess = true if word == guess.join.gsub(' ', '')

    if (incorrect_guess_remaining == 0 || correct_guess)
      puts word
      puts 'Game over'
      break
    end
  end
end

game()
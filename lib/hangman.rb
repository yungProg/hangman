require 'json'

def clean_game_dictionary(dic)
  dic.map! { |vocab| vocab.strip.downcase }
  dic.select! { |vocab| vocab.length > 4 && vocab.length < 13 }
end

def take_user_input
  alphabets = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  loop do
    puts 'Enter guess'
    player_guess = gets.chomp!.downcase
    if player_guess.length == 1 && alphabets.include?(player_guess)
      return player_guess
    end
  end
end

def save_game(state)
  File.open('save.txt', 'w') do |file|
    file.puts(state.to_json)
  end
end

def load_game
  if File.exist?('save.txt')
    state = JSON.parse(File.read('save.txt'))
    p state
  end
end

def game
  game_dictionary = File.readlines('google-10000-english-no-swears.txt')

  word =   clean_game_dictionary(game_dictionary).sample
  word_arr = word.split('')

  incorrect_guess_remaining = 6
  incorrect_letters = []
  correct_guess = false

  guess = []
  word.length.times { guess.push('_ ') }

  puts '_ '*word.length

  loop do
    player_guess = take_user_input

    frequency = word.count(player_guess)
    if (frequency == 0 && !incorrect_letters.include?(player_guess))
      incorrect_letters.push(player_guess) 
      incorrect_guess_remaining -= 1
      puts "Incorrect guess remaining: #{incorrect_guess_remaining}"
    end
    puts incorrect_letters.inspect unless incorrect_letters.empty?
    
    frequency.times do
      word_index = word_arr.index(player_guess)
      if word_index
        guess[word_index] = player_guess + ' '
        word_arr[word_index] = nil
      end
    end

    puts guess.join
    correct_guess = true if word == guess.join.gsub(' ', '')

    # save_game([word, incorrect_guess_remaining, incorrect_letters, guess]) 
    save_game({
      :word => word,
      :incorrect_guess_remaining => incorrect_guess_remaining,
      :incorrect_letters => incorrect_letters,
      :guess => guess
    })

    if (incorrect_guess_remaining == 0 || correct_guess)
      puts word
      puts 'Game over'
      break
    end
  end
  replay()
end

def play
  puts 'Welcome to Hangman'
  game()
end

def replay
  puts 'Do you want to play again? (Yes/No)'
  play_another_round = gets.chomp.downcase
  game() if play_another_round == 'yes'
end

load_game
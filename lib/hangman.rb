require 'json'

class Hangman
  def initialize
    @word
    @incorrect_guess_remaining = 6
    @incorrect_letters = []
    @guess = []
    @game_dictionary = File.readlines('google-10000-english-no-swears.txt')
    @correct_guess? = false
  end

  def save_state(state)
    File.open('save.json', 'w') do |file|
      file.puts(state.to_json)
    end
  end

  def load_state
    if File.exist?('save.json')
      state = JSON.parse(File.read('save.json'))
      p state
    end
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

  def clean_game_dictionary(dic)
    dic.map! { |vocab| vocab.strip.downcase }
    dic.select! { |vocab| vocab.length > 4 && vocab.length < 13 }
  end

  def check_guess(guessed_letter)
    frequency = @word.count(guessed_letter)
      if (frequency == 0 && !@incorrect_letters.include?(guessed_letter))
        @incorrect_letters.push(guessed_letter) 
        @incorrect_guess_remaining -= 1
        puts "Incorrect guess remaining: #{@incorrect_guess_remaining}"
      end
    end
  end

  def update(guessed_letter)
    frequency = @word.count(guessed_letter)
    frequency.times do
      word_index = @word_arr.index(player_guess)
      if word_index
        @guess[word_index] = player_guess + ' '
        word_arr[word_index] = nil
      end
    end
  end

  def game
    puts 'Welcome to Hangman'

    @word =   clean_game_dictionary(@game_dictionary).sample
    word_arr = @word.split('')
    
    @word.length.times { @guess.push('_ ') }
  
    puts '_ '*word.length
  
    loop do
      player_guess = take_user_input
      check_guess(player_guess)

      puts @incorrect_letters.inspect unless incorrect_letters.empty?
  
      puts @guess.join
      @correct_guess? = true if @word == @guess.join.gsub(' ', '')
  
      save_state({
        :word => @word,
        :incorrect_guess_remaining => @incorrect_guess_remaining,
        :incorrect_letters => @incorrect_letters,
        :guess => @guess
      })
  
      if (@incorrect_guess_remaining == 0 || @correct_guess?)
        puts @word
        puts 'Game over'
        break
      end
    end
    replay()
  end

  def replay
    puts 'Do you want to play again? (Yes/No)'
    play_another_round = gets.chomp.downcase
    game() if play_another_round == 'yes'
  end
end
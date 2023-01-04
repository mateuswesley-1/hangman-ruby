require_relative 'get_data'
require_relative 'basic_serializable'
require 'json'

class Hangman
  # Simple Hangman game with a save option

  # module that download words from net and creates a array
  include Getdata

  # Serialization module
  include BasicSerializable

  # attr_reader :secret_word, :wrong_tries, :draw
  # getting array of words using module methods
  WORDS = Getdata.txt_to_array
  # number of tries before lose
  MAX_TRY = 10



  def initialize
    # If the game status if true, theres a hang game game going on
    @game_status = true
    # The random secret word and the Array that
    # store the right guesses
    @secret_word = WORDS.sample
    @draw = Array.new(@secret_word.length, '_')
    # All the letters that have been already tried
    # and the number of wrong tries
    @tried_letters = []
    @wrong_tries = 0
    # Defines if we'll be a new game of a loaded game
    @game_mode = game_mode
    # Listed of saved games
    @saved_users = saved_users
    # use @game_mode to define the mode that we get user name, if is a loaded game, the options are
    # limited to that ones in the users.txt list.
    case @game_mode
    when 1
      @user = read_user_name
    when 2
      load_game
    end
  end

  def save_game(user_name)
    Dir.mkdir('saves') unless Dir.exist? 'saves'
    filename = "saves/game_#{user_name}.json"

    # adiciona os dados do jogo atual ao arquivo
    # associado ao usuario
    File.open(filename, 'w') do |file|
      save_user
      file.puts(self.serialize)
    end
  end

  def read_user_name
    puts 'Provide a valid username: '
    gets.chomp.strip
  end

  def game_mode
    puts "1 - New Game \n2 - Load game\n"
    gets.chomp.to_i
  end

  def load_game
    choose_save
    read_save_data
  end

  # print users that have a saved game
  def saved_users
    users_file = 'saves/users.txt'
    array_users = []

    # Create the file if there is none
    File.open(users_file, 'w') {} unless File.exist? users_file

    File.open(users_file, 'r') do |file|
      array_users << file.readline.chomp until file.eof?
    end
    array_users
  end

  def choose_save
    puts "Users with saved games: \n"
    @saved_users.each do |user, idx|
      puts "      #{user}"
    end
    until @saved_users.include? @user
      puts "\nProvide a valid user: "
      @user = gets.chomp.strip.downcase
    end
  end

  def read_save_data
    file_name = "saves/game_#{@user}.json"
    File.open(file_name, 'r') do |file|
      unserialize(file.read)
    end
  end

  def save_user
    file_users = 'saves/users.txt'
    open_mode = File.exist?(file_users) ? 'a' : 'w'

    # So adiciona o nome na lista se nao existir
    return if @saved_users.include? @user

    File.open(file_users, open_mode) do |file|
      file.puts(@user)
      @saved_users.push(@user)
    end
  end

  def read_letter
    while true
      # give the user feedback, wrong letters, right letters etc..
      feedback
      # get user letter
      while true
        puts "\n\n"
        puts "********************************************************"
        puts "\n\n"
        print "Hello, #{@user.capitalize}. Try a letter, write 'save' to save the game, or 'exit' to leave: "
        @letter = gets.chomp.strip.downcase

        # close the game
        if @letter == 'exit'
          @game_status = false
          return
        end

        # save the game
        break unless @letter == 'save'

        puts 'Game saved!'
        save_game(@user)
        next
      end

      # check if is a letter or is has been already choosen
      next if invalid_letter?

      @tried_letters << @letter
      break
    end
  end

  def check_letter
    letters_changed = false
    @secret_word.split('').each_with_index do |char, idx|
      if char == @letter
        @draw[idx] = @letter
        letters_changed = true
      end
    end
    @wrong_tries += 1 if letters_changed == false
  end

  def invalid_letter?
    @tried_letters.include?(@letter) || @letter.match?(/[^a-zA-Z]/)
  end

  def feedback
    puts "Tried letters: #{@tried_letters}"
    puts "Wrong tries: #{@wrong_tries}"
    puts @draw.join(' ').to_s
  end

  def round
    read_letter
    check_letter
  end

  def game_on?
    @wrong_tries < MAX_TRY && @secret_word != @draw.join
  end

  def check_win
    @winner = @secret_word == @draw.join
  end

  # msg for the end of the game
  def end_msg
    return "\nCongratulations, #{@user.capitalize}! you got the secret word right" if @winner
    return "\nSee you later, #{@user.capitalize}!" if @letter == 'exit'
    return "\nYou failed to guess the secret word, #{@user.capitalize}. Better luck next time" if @winner == false && @letter != 'exit'
  end

  def game
    while @game_status == true
      @game_status = game_on?
      round
      check_win
    end

    puts end_msg
  end
end

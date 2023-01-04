module Getdata
  # download txt with words from web and create array with words
  require 'open-uri'
  @@url ='https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt'
  @@local_filename = 'words.txt'


  def self.download_txt
    URI.open(@@url) do |file_web|
      File.open(@@local_filename, 'w') do |local_file|
        local_file.write(file_web.read)
      end
    end
  end

  def self.txt_to_array
    array = []
    File.open(@@local_filename, 'r') do |local_file|
      until local_file.eof?
        word = local_file.readline.chomp
        array << word if word.length.between? 5, 12
      end
    end
    array
  end

end

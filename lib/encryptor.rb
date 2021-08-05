require './lib/offset'
require './lib/key_maker'

class Encryptor
  include KeyMaker
  attr_reader :message, :key, :date, :offsets

  ALPHABET = ('a'..'z').to_a << ' '

  def initialize(message, key, date)
    @message = message.downcase
    @date = date
    @key = key
    @offsets = Offset.offsets(@key, @date)
  end

  def encrypted_message
    @message.chars.each_with_index.map do |letter, i|
      if ALPHABET.include?(letter)
        next_letter(letter, i)
      else
        letter
      end
    end.join
  end

  def next_letter(letter, i)
    ALPHABET[next_index(letter, @offsets[i % 4])]
  end

  def next_index(letter, shift)
    (ALPHABET.index(letter) + shift) % ALPHABET.size
  end

  def format_encryption
    {
      encryption: encrypted_message,
      key: @key,
      date: @date
    }
  end

  def self.format_today(date=Time.now)
    date.strftime("%d%m") + date.strftime("%Y")[2..]
  end

  def self.encrypt(message, key=make_key_string, date=format_today)
    Encryptor.new(message, key, date).format_encryption
  end
end

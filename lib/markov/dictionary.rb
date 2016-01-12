
require 'securerandom'

class Markov::Dictionary
  include Markov::Util
  
  def initialize(depth)
    @depth = depth
    
    @dictionary = {}
    @start_words = {}
    
    srand
  end
    
  def empty?
    @dictionary.empty?
  end
  
  def dump_startwords
    @start_words.keys.each do |start_words|
      puts "#{start_words} -> #{tokens_to_sentence @dictionary[start_words]}"
    end
  end
  
  def dump_dictionary
    @dictionary.keys.each do |keys|
      following = @dictionary[keys]
      sentence = []
      following.each do |word|
        sentence << "#{word.to_s},"
      end
      s = sentence.join(" ")
      puts "#{keys} => #{s.slice(0,s.length-1)}"
    end
  end
  
  def add_to_start_words(tokens)
    return if tokens[0].kind != :word
    
    tokens[0].word = tokens[0].word.capitalize
    start_words = tokens_to_words tokens
    
    @start_words[start_words] ||= tokens
  end
  
  def add_to_dictionary(tokens)
    token = tokens.last
    return if token == nil || token.word == ""
    
    key_words = tokens_to_words tokens[0, @depth-1]     
    
    @dictionary[key_words] ||= []
    @dictionary[key_words] << token
  end
    
  def select_start_words
    @start_words[ @start_words.keys[random_number( @start_words.keys.length-1)]]
  end
  
  def select_next_token(tokens)
    token = @dictionary[ tokens_to_words(tokens)]
    
    return Markov::Token.new("X", :noop) if token == nil  
    token[random_number(tokens.length-1)]
  end
  
  def select_next_word(tokens)
    token = nil
    begin
      token = select_next_token(tokens)
    end until token.kind == :word
    token
  end
  
end
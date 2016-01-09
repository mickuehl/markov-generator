
require 'markov/token'

class Markov::Parser

  def initialize
    @split_sentence = /(?<=[.?!])\s+/
    @split_words = /([,.?!])|[\s]/
    @replace_chars = /[„':;_"()]/
    
    @unparsed_sentences = []
    @tokens = []
  end
  
  class FileNotFoundError < Exception # :nodoc:
  end
  
  class EmptyDictionaryError < Exception # :nodoc:
  end
  
  def load_text(source)
    
    if File.exists?(source)
      sentences = File.open(source, "r").read.force_encoding(Encoding::UTF_8).split(@split_sentence)
    else
      raise FileNotFoundError.new("#{source} does not exist!")
    end
    
    sentences.each do |sentence|
      add_unparsed_sentence sentence
    end
    
  end 
  
  def next_token
    
    if @tokens.empty?
      sentence = @unparsed_sentences.slice!(0)
      if sentence
        sentence.each do |word|
          
          if word.include?(",")
            @tokens << Markov::Token.new(",", :special)
          elsif word.include?("?")
            @tokens << Markov::Token.new("?", :stop)
          elsif word.include?("!")
            @tokens << Markov::Token.new("!", :stop)
          elsif word.include?(".")
            @tokens << Markov::Token.new(".", :stop)
          elsif word == ""
            # skip blanks
          else
            @tokens << Markov::Token.new(word, :word)
          end            
        end
      else
        @tokens = nil
      end
    end
    
    return @tokens.slice!(0) if @tokens
    
    @tokens = []
    nil  
  end # end next_token
  
  private
  
  def add_unparsed_sentence(sentence)
    
    sentence.gsub!(@replace_chars, "")
    words = sentence.split(@split_words)
    if words && !words.empty?
      @unparsed_sentences << words
    end
    
  end # add_unparsed_sentence
  
end

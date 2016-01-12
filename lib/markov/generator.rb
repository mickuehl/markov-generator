
require 'securerandom'

class Markov::Generator
  include Markov::Util
  
  def initialize(depth)
    @depth = depth
    @unparsed_sentences = []
    @tokens = []
    
    @dict = Markov::Dictionary.new(depth)
    
    srand
  end
  
  def parse_text(source)
    
    parser = Markov::Parser.new
    parser.load_text source
    
    state = :start # :start, :word, :special, :stop
    word_seq = []
    
    begin
      while token = parser.next_token
        
        if state == :start
          word_seq << token
          
          # fill the array
          (@depth-word_seq.size).times do
            word_seq << parser.next_token
          end
          
          # need to store the words in both the dictionary 
          # and the list of start words
          @dict.add_to_start_words word_seq[0, @depth-1]
          @dict.add_to_dictionary word_seq
          
          token = parser.next_token
          state = :sentence
        end
        
        if state == :sentence
          # move the array one position
          word_seq.slice!(0)
          word_seq << token
          
          # add to the dictionary
          @dict.add_to_dictionary word_seq
          
          # stop current sequence and start again
          if token == nil || token.kind == :stop
            word_seq = []
            state = :start
          end  
        end
        
      end
    rescue => e
      # nothing to rescue
      puts e
      puts e.backtrace
    end
    
  end # end parse_text
  
  def generate_sentence(min_length=15)
    if @dict.empty?
      raise EmptyDictionaryError.new("The dictionary is empty! Parse a source file/string first!")
    end
    
    tokens = []
    complete_sentence = false
    
    # initialize
    @dict.select_start_words.each {|w| tokens << w}
    prev_token = tokens.last
    
    begin
      token =  @dict.select_next_token tokens.last(@depth-1)
      
      if token.kind == :word
        tokens << token
        prev_token = token
      elsif token.kind == :special
        if prev_token.kind == :word
          tokens << token
          prev_token = token
        end
      elsif token.kind == :stop
        if prev_token.kind == :word
          tokens << token
          prev_token = token
        end
      elsif token.kind == :noop
        if prev_token.kind == :word
          tokens << Markov::Token.new(".", :stop)
        end
        # start a new sentence
        @dict.select_start_words.each {|w| tokens << w}
        prev_token = tokens.last
      end
      
      if (token.kind == :stop) && (tokens.size > min_length)
        #puts "-- DONE(#{tokens.size}) #{tokens_to_debug tokens}"
        return tokens_to_sentence tokens
      end
      
      # default circuit-breaker
      if tokens.size > min_length * 4
        # restart
        tokens = []
        complete_sentence = false
    
        # initialize
        @dict.select_start_words.each {|w| tokens << w}
        prev_token = tokens.last
      end
      
    end until complete_sentence
    
    tokens_to_sentence tokens
  end
  
  def dump_startwords
    @start_words.keys.each do |start_words|
      puts "#{start_words}"
    end
  end
  
  def dump_dictionary
    @dict.dump_dictionary
  end
  
  def dump_startwords
    @dict.dump_startwords
  end
  
end
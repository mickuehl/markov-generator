
require 'securerandom'

class Markov::Generator

  def initialize(depth)
    @depth = depth
    
    @dictionary = {}
    @start_words = {}
    @unparsed_sentences = []
    @tokens = []
    
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
          add_to_start_words word_seq[0, @depth-1]
          add_to_dictionary word_seq
          
          token = parser.next_token
          state = :sentence
        end
        
        if state == :sentence
          # move the array one position
          word_seq.slice!(0)
          word_seq << token
          
          # add to the dictionary
          add_to_dictionary word_seq
          
          # stop current sequence and start again
          if token.kind == :stop
            word_seq = []
            state = :start
          end  
        end
        
      end
    rescue => e
      # nothing to rescue
      puts e
    end
    
  end # end parse_text
  
  def generate_sentence(min_length=20)
    if @dictionary.empty?
      raise EmptyDictionaryError.new("The dictionary is empty! Parse a source file/string first!")
    end
    
    tokens = []
    complete_sentence = false
    
    # initialize
    select_start_words.each {|w| tokens << w}
    prev_token = tokens.last
    
    begin
      token =  select_next_token tokens.last(@depth-1)
      
      if token.kind == :stop
        token =  select_next_word tokens.last(@depth-1) if prev_token.kind == :special
        tokens << token
      elsif token.kind == :special
        token =  select_next_word tokens.last(@depth-1) if prev_token.kind == :special
        tokens << token
      elsif token.kind == :noop
        token = Token.new(".", :stop)
        tokens[tokens.length-1] = token
      else
        tokens << token
      end
      
      prev_token = token
      
      if token.kind == :stop
        if tokens.size < min_length
          select_start_words.each {|w| tokens << w}
          prev_token = tokens.last
        else
          complete_sentence = true
        end
      end
      
      # circuit-breaker
      complete_sentence = true if tokens.size > min_length*2 
    end until complete_sentence
    
    tokens_to_sentence tokens
  end #end generate_sentence
  
  def dump_startwords
    @start_words.keys.each do |start_words|
      puts "#{start_words}"
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
  
  private
  
  def add_to_start_words(tokens)
    return if tokens[0].kind != :word
    
    tokens[0].word = tokens[0].word.capitalize
    start_words = tokens_to_words tokens
    
    @start_words[start_words] ||= tokens
  end
  
  def add_to_dictionary(tokens)
    token = tokens.last
    return if token.word == ""
    
    key_words = tokens_to_words tokens[0, @depth-1]     
    
    @dictionary[key_words] ||= []
    @dictionary[key_words] << token
  end
  
  def tokens_to_words(tokens)
    words = []
    tokens.each do |t|
      words << t.word
    end
    words
  end
  
  def tokens_to_sentence(tokens)
    s = ""
    tokens.each do |t|
      if t.kind != :word
        s << t.word
      else
        s << " " + t.word
      end
    end
  
    s[1, s.length-1]
  end
  
  def select_start_words
    @start_words[ @start_words.keys[random_number( @start_words.keys.length-1)]]
  end
  
  def select_next_token(tokens)
    token = @dictionary[ tokens_to_words(tokens)]
    
    return Token.new("X", :noop) if token == nil  
    token[random_number(tokens.length-1)]
  end
  
  def select_next_word(tokens)
    token = nil
    begin
      token = select_next_token(tokens)
    end until token.kind == :word
    token
  end
  
  def random_number(upper_limit)
    (SecureRandom.random_number * upper_limit).to_i
  end
  
end
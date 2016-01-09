
require 'securerandom'

module Markov
  
  class Token < Struct.new(:word, :kind)
    # used as an internal structure to hold words etc
  end
  
  class Generator
    
    attr_reader :depth
    
    def initialize(depth=3)
      @depth = depth
      
      @split_sentence = /(?<=[.?!])\s+/
      @split_words = /([,.?!])|[\s]/
      @replace_chars = /[„':;_"()]/
      
      @dictionary = {}
      @start_words = {}
      @unparsed_sentences = []
      @tokens = []
      srand
    end
    
    class FileNotFoundError < Exception # :nodoc:
    end
    
    class EmptyDictionaryError < Exception # :nodoc:
    end
    
    def parse_string(sentence)
      add_unparsed_sentence sentence
      parse_text
    end
    
    def parse_source_file(source)
      
      if File.exists?(source)
        sentences = File.open(source, "r").read.force_encoding(Encoding::UTF_8).split(@split_sentence)
      else
        raise FileNotFoundError.new("#{source} does not exist!")
      end
      
      sentences.each do |sentence|
        add_unparsed_sentence sentence
      end
      
      parse_text
      
    end
    
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
    end
      
    def dump_start_words
      @start_words.keys.each do |words|
        puts "#{words[0]},#{words[1]}"
      end
    end
    
    def dump_dictionary
      @dictionary.keys.each do |words|
        following = @dictionary[words]
        sentence = "#{words[0]},#{words[1]},"
        following.each do |s|
          sentence << "#{s.word},"
        end
        
        puts "#{sentence.slice(0,sentence.length-1)}"
      end
    end
    
    def dump_dictionary_stats
      puts "Keys: #{@dictionary.keys.size}"
      dist = {}
      n = 0
      @dictionary.keys.each do |words|
        following = @dictionary[words]
        size = following.size
        if dist[size]
          dist[size] = dist[size] + 1
        else
          dist[size] = following.size
        end
        n = n + 1
      end
      
      dist.keys.sort.each do |s|
        percentage = ((dist[s].to_f/n.to_f)*100).to_i
        puts "BUCKET: #{s}\t=#{dist[s]} (#{percentage}%)" if percentage > 0
      end
      n
    end
    
    private
    
    def parse_text
            
      state = :start # :start, :word, :special, :stop
      word_seq = []
      
      begin
        while token = next_token
          
          if state == :start
            word_seq << token
            
            # fill the array
            (@depth-word_seq.size).times do
              word_seq << next_token
            end
            
            # need to store the words in both the dictionary 
            # and the list of start words
            add_to_start_words word_seq[0, @depth-1]
            add_to_dictionary word_seq
            
            token = next_token
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
          
        end # end while
        
      rescue
        # nothing to rescue
      end
      
    end # end parse_text
    
    def next_token
      
      if @tokens.empty?
        sentence = @unparsed_sentences.slice!(0)
        if sentence
          sentence.each do |word|
            
            if word.include?(",")
              @tokens << Token.new(",", :special)
            elsif word.include?("?")
              @tokens << Token.new("?", :stop)
            elsif word.include?("!")
              @tokens << Token.new("!", :stop)
            elsif word.include?(".")
              @tokens << Token.new(".", :stop)
            elsif word == ""
              # skip blanks
            else
              @tokens << Token.new(word, :word)
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
    
    def add_unparsed_sentence(sentence)
      
      sentence.gsub!(@replace_chars, "")
      words = sentence.split(@split_words)
      if words && !words.empty?
        @unparsed_sentences << words
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
  
end

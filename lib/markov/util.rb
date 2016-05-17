
require 'securerandom'

module Markov::Util

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

  def tokens_to_debug(tokens)
    s = ""
    tokens.each do |t|
      if t.kind != :word
        s << " " + t.to_symbol
      else
        s << " " + t.word
      end
    end

    s[1, s.length-1]
  end

  def random_number(upper_limit)
    (SecureRandom.random_number * upper_limit).to_i
  end

end

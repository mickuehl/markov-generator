
class Markov::Token < Struct.new(:word, :kind)
  # used as an internal structure to hold words etc
  #
  # word => string
  # kind => :start, :word, :special, :stop
  
  def to_s
    "#{kind}(#{word})"
  end
  
  def to_symbol
    if kind == :word
      "WORD"
    elsif kind == :special
      "S(#{word})"
    else
      "STOP(#{word})"
    end
  end
  
end
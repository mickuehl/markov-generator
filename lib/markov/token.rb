
class Markov::Token < Struct.new(:word, :kind)
  # used as an internal structure to hold words etc
  #
  # word => string
  # kind => :start, :word, :special, :stop
  
  def to_s
    "#{kind}(#{word})"
  end
end

module Markov
  
  require 'markov/util'
  require 'markov/token'
  require 'markov/parser'
  require 'markov/dictionary'
  require 'markov/generator'
  
  def generator(depth=3)
    return Markov::Generator.new(depth)
  end
  
  module_function :generator
end

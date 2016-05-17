
module Markov
  
  require 'markov/util'
<<<<<<< HEAD
  
  #def generator(depth=3)
  #  return Markov::Generator.new(depth)
  #end
  
  #module_function :generator
=======
  require 'markov/token'
  require 'markov/parser'
  require 'markov/dictionary'
  require 'markov/generator'
  
  def generator(depth=3)
    return Markov::Generator.new(depth)
  end
  
  module_function :generator
>>>>>>> c81eb8e0ab6d7178faa1c353d9c8cb6ef15e80dd
end

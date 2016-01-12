
require 'securerandom'

module Markov::Util
  
  def random_number(upper_limit)
    (SecureRandom.random_number * upper_limit).to_i
  end
  
end
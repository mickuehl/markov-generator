
require 'markov/generator'

markov = Markov::Generator.new
markov.parse_source_file "./test_seed.txt"

puts "#{markov.generate_sentence}"

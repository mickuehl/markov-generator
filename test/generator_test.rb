$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'markov'

markov = Markov.generator(3)
markov.parse_text "./test/texts/generator_test.txt"

markov.dump_dictionary
puts ""

1..5.times do
  puts "#{markov.generate_sentence}"
  puts ""
end

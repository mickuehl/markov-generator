$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'markov'

markov = Markov.generator(3)

markov.parse_text "./test/texts/alice.txt"
markov.parse_text "./test/texts/grimm.txt"

#markov.dump_startwords
#markov.dump_dictionary

1..25.times do
  puts "\n#{markov.generate_sentence}"
end

puts "\n"

require 'markov/generator'

markov = Markov::Generator.new
markov.parse_source_file "./generator_test2.txt"
markov.parse_source_file "./generator_test1.txt"

#markov.dump_dictionary
#markov.dump_start_words
markov.dump_dictionary_stats

1..5.times do
  puts "#{markov.generate_sentence}"
end


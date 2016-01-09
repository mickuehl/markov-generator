
require 'markov/generator'

markov = Markov::Generator.new

Dir["../../personal_markov_texts/usenet/*.txt"].each do | f |
  puts "*** Analyzing '#{f}' "
  markov.parse_source_file f
end

markov.dump_dictionary_stats

1..5.times do
  puts "\n#{markov.generate_sentence 60}"
end

#markov.dump_dictionary

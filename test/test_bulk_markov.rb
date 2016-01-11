$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'markov'

source_dir = ARGV[0]

markov = Markov.generator(3)

Dir["#{source_dir}/*.txt"].each do | f |
  puts "*** Analyzing '#{f}' "
  markov.parse_text f
end

#markov.dump_startwords
#markov.dump_dictionary

1..5.times do
  puts "\n#{markov.generate_sentence}"
end

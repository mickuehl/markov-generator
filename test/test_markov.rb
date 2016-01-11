$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'markov'

source = ARGV[0]

markov = Markov.generator(3)
markov.parse_text source

#markov.dump_startwords
markov.dump_dictionary
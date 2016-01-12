
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'markov'

source = ARGV[0]

parser = Markov::Parser.new
parser.load_text source

while token = parser.next_token
  puts token
end
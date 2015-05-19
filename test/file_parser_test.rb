
require 'markov/generator'

#markov = Markov::Generator.new
#markov.parse_source_file "./test_seed.txt"

#puts "#{markov.generate_sentence}"

#@split_words = /([',.?!\n-])|[\s]+/
#@split_sentence = /(?<=[.!?\n])\s+/

split_sentence = /(?<=[.?!])\s+/
split_words = /([,.?!])|[\s]/
replace_chars = /[„':;_"()]/

#source = "./file_parser_test.txt"
source = "./seed_alts1.txt"

sentences = File.open(source, "r").read.force_encoding(Encoding::UTF_8).split(split_sentence)

sentences.each do |sentence|
  puts sentence
  puts sentence.gsub!( replace_chars, "")
  puts "#{sentence.split(split_words)}"
end
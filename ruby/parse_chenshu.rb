# frozen_string_literal: true

require 'json'
require_relative './util.rb'

counter = 0
# the first chapter has some encoding problem, have to hack it
chapter = nil
json_array = []
regex = /\s+\*\*\*\*\*\*\*\*\*\*\*\*(\S+)第\S+\s+(.*)\s+/
File.open('utf8/09陈书.TXT', 'r') do |utf8_input|
  utf8_input.each_line do |line|
    # Check if it is a new chapter
    chapter_parts = line.scan(regex)
    unless chapter_parts.empty?
      chapter = chapter_parts[0][0] + ' ' + chapter_parts[0][1].strip
      counter += 1
      puts "Processing chapter #{chapter}"
      next
    end

    # Process each chapter
    unless line.strip.empty?
      # puts "Dumping: #{line.strip}"
      json_array << generate_paragraph_json('陈书', chapter, line.strip)
    end
    counter += 1

    # break if counter > 10
  end

  # puts json_array
  File.open('json/chenshu.json', 'w') do |json_output|
    json_output.write(JSON.pretty_generate(json_array))
  end
end
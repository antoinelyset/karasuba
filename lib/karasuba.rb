require 'nokogiri'

require 'karasuba/version'
require 'karasuba/todo'
require 'karasuba/todo_list'
require 'karasuba/link'
require 'karasuba/finder'

class Karasuba
  attr_reader :parsed

  def initialize(note_or_string)
    @finder = Finder.new
    parser = Nokogiri::XML::SAX::Parser.new(@finder)
    if note_or_string.respond_to?(:content)
      parser.parse(note_or_string.content)
    else
      parser.parse(note_or_string)
    end
  end

  def todos
    @finder.todos
  end
end


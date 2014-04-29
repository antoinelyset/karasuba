require 'nokogiri'

require 'karasuba/version'
require 'karasuba/todo'
require 'karasuba/link'
require 'karasuba/link_appender'
require 'karasuba/finder'

class Karasuba
  attr_reader :parsed, :finder

  def initialize(note_or_string)
    @parsed = if note_or_string.respond_to?(:content)
      Nokogiri.parse(note_or_string.content)
    else
      Nokogiri.parse(note_or_string)
    end
    @finder = Finder.new(parsed)
  end

  def todos
    finder.todos
  end
end


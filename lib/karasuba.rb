require 'nokogiri'

require 'karasuba/version'
require 'karasuba/todo'
require 'karasuba/finder'

class Karasuba
  attr_reader :parsed
  def initialize(note_or_string)
    @parsed = if note_or_string.respond_to?(:content)
      Nokogiri.parse(note_or_string.content)
    else
      Nokogiri.parse(note_or_string)
    end
  end

  def todos
    Karasuba::Finder.new(parsed).todos
  end
end


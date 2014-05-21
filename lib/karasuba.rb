require 'nokogiri'

require 'karasuba/version'
require 'karasuba/todo'
require 'karasuba/link'
require 'karasuba/link_appender'
require 'karasuba/footer_appender'
require 'karasuba/note'

class Karasuba
  attr_reader :xml, :note

  def initialize(note_or_string)
    @xml = if note_or_string.respond_to?(:content)
      Nokogiri.parse(note_or_string.content)
    else
      Nokogiri.parse(note_or_string)
    end
    @note = Note.new(xml)
  end

  def todos
    note.todos
  end
end


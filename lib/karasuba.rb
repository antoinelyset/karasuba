require 'nokogiri'
require 'equivalent-xml'

require 'karasuba/version'
require 'karasuba/todo'
require 'karasuba/link'
require 'karasuba/link_appender'
require 'karasuba/footer_appender'
require 'karasuba/parser'
require 'karasuba/note'

class Karasuba
  attr_reader :xml, :note

  # @attr note_or_string [String/#content]
  # @options { ignore_link: { href: [String/Regexp], content: [String/Regexp] },
  #            stop_link:   { href: [String/Regexp], content: [String/Regexp] } }
  def initialize(note_or_string, options = {})
    @xml = if note_or_string.respond_to?(:content)
      Nokogiri.parse(note_or_string.content)
    else
      Nokogiri.parse(note_or_string)
    end
    @note = Note.new(xml, options)
  end

  def equivalent?(doc_or_string)
    note.equivalent?(doc_or_string)
  end

  def todos
    note.todos
  end
end


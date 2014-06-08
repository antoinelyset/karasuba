class Karasuba
  class Note
    attr_reader :xml, :todos, :options

    def initialize(xml, options = {})
      @xml            = xml
      @options        = options
      @todos          = []
      @todo_elements  = xml.xpath('//en-todo')
      instanciate_todos
    end

    def append_footer(text, options = {})
      appender = FooterAppender.new(append_footer_point)
      appender.append_footer(text, options)
    end

    def equivalent?(doc_or_string)
      doc_or_string = Nokogiri.parse(doc_or_string) if doc_or_string.is_a?(String)
      EquivalentXml.equivalent?(self.xml, doc_or_string, element_order: true, normalize_whitespace: true)
    end

    def footer?(title)
      !!self.xml.xpath("//*[attribute::title=\"#{title}\"]").last
    end

    private

    def instanciate_todos
      @todos = @todo_elements.map { |todo| Parser.new(todo, options).parse }
    end

    def append_footer_point
      # The second part is a hack, it adds a div to the en-note body
      #   in order to have an append point
      self.xml.xpath('//en-note/child::*[position()=last()]').first ||
        ( self.xml.xpath('//en-note').first.children = Nokogiri::XML::Node.new('div', xml))
    end
  end
end

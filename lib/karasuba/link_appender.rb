class Karasuba
  class LinkAppender
    attr_reader :append_point

    def initialize(append_point)
      @append_point = append_point
    end

    def append_link(href, text = '')
      node = Nokogiri::XML::Node.new('a', document)
      node['href'] = href
      node.content = text
      append_point.next = node
    end

    def document
      append_point.document
    end
  end
end

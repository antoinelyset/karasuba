class Karasuba
  # A footer should look like this :
  # <div title="a-footer-id">
  #   <hr style="margin: 15px 0px;"/>
  #   <p display="color:#878888;">
  #     Lorem ipsum<br/>
  #     Lauren hipsum
  #   </p>
  # </div>
  class FooterAppender
    attr_reader :append_point

    def initialize(append_point)
      @append_point = append_point
    end

    def append_footer(text_or_array = '', options = {})
      text_array = Array(text_or_array)
      hr         = horizontal_rule(options)
      p          = paragraph(text_nodes(text_array), options)
      div        = division(hr, p, options)
      br         = break_element(options)
      footer     = Nokogiri::XML::NodeSet.new(document, [br, div])
      append_point.next = footer
      footer
    end

    def document
      append_point.document
    end

    private

    def break_element(options)
      Nokogiri::XML::Node.new('br', document)
    end

    def text_nodes(text_array)
      nodes = text_array.inject([]) do |ary, text|
        ary << Nokogiri::XML::Text.new(text, document)
        ary << Nokogiri::XML::Node.new('br', document)
      end
      nodes.tap(&:pop)
    end

    def paragraph(nodes, options)
      p          = Nokogiri::XML::Node.new('p', document)
      p['style'] = options[:style][:paragraph_style] if options[:style]
      p.children = Nokogiri::XML::NodeSet.new(document, nodes)
      p
    end

    def horizontal_rule(options)
      hr          = Nokogiri::XML::Node.new('hr', document)
      hr['style'] = options[:style][:horizontal_rule_style] if options[:style]
      hr
    end

    def division(hr, p, options)
      div          = Nokogiri::XML::Node.new('div', document)
      div['title'] = options[:title]
      div['style'] = options[:style][:division_style] if options[:style]
      div.children = Nokogiri::XML::NodeSet.new(document, [hr,p])
      div
    end
  end
end

class Karasuba
  # A footer should look like this :
  # <div title="a-footer-id">
  #   </br>
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

    def append_footer(xml_text = '', options = {})
      hr         = horizontal_rule(options)
      p          = paragraph(text_nodes(xml_text), options)
      div        = division(hr, p, options)
      append_point.next = div
      div
    end

    def document
      append_point.document
    end

    private

    def break_element(options = {})
      Nokogiri::XML::Node.new('br', document)
    end

    def text_nodes(xml_text)
      Nokogiri::XML::DocumentFragment.parse(xml_text).children
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
      div['title'] = options[:title] if options[:title]
      div['style'] = options[:style][:division_style] if options[:style]
      br           = break_element
      div.children = Nokogiri::XML::NodeSet.new(document, [br, hr, p])
      div
    end
  end
end

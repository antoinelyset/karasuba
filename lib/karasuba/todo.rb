class Karasuba
  class Todo
    MAX_TRIES = 3

    attr_reader :element, :text, :link, :following_title_nodes

    def initialize(element)
      @element = element
      find_text(element)
      find_checked
      find_link
    end

    def checked?
      @checked
    end

    def add_link(url, text = '')
      node = Nokogiri::XML::Node.new('a', element.document)
      node['href'] = url
      node.content = text
      following_title_nodes.last.before(node)
    end

    private

    def find_text(el, try = 0)
      @text = get_text(get_following_title_nodes)
    end

    def find_checked
      @checked = if element.attribute('checked')
                   element.attribute('checked').value == 'true'
                 else
                   false
                 end
    end

    def find_link
      node = following_title_nodes.last.previous
      @link = node.name == 'a' ? node : nil
    end

    def get_following_title_nodes(el = element, try = 0)
      xpath = './following-sibling::node()[following-sibling//en-todo|//en-note|//br]'
      nodes = el.xpath(xpath)
      value = get_text(nodes)
      @following_title_nodes = if value == '' && try != MAX_TRIES
                                 get_following_title_nodes(el.parent, try+1)
                               else
                                 nodes
                               end
    end

    def get_text(nodes)
      nodes.inject('') { |t, n| t + n.text }.strip
    end
  end
end

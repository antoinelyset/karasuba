class Karasuba
  class Todo
    MAX_TRIES = 3
    attr_reader :element, :text

    def initialize(element)
      @element = element
      find_text(element)
      find_checked
    end

    def checked?
      @checked
    end

    private

    def find_text(element, try = 0)
      xpath = './following-sibling::node()[following-sibling//en-todo|//en-note|//br]'
      nodes = element.xpath(xpath)
      value = get_text(nodes)
      @text = if value == ''
                 try == MAX_TRIES ? '' : find_text(element.parent, try+1)
              else
                value
              end
    end

    def find_checked
      @checked = if element.attribute('checked')
                   element.attribute('checked').value == 'true'
                 else
                   false
                 end
    end

    def get_text(nodes)
      nodes.inject('') { |t, n| t + n.text }.strip
    end
  end
end

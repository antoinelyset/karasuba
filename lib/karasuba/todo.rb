class Karasuba
  class Todo
    attr_accessor :element, :title, :following_siblings,
      :stopping_sibling, :text_sibblings, :stopped_by_link, :options

    def initialize(element, title =  '', following_siblings = [], text_sibblings = [], options = {})
      @element            = element
      @title              = title
      @following_siblings = following_siblings
      @stopping_sibling   = nil
      @stopped_by_link    = false
      @text_sibblings     = text_sibblings
      @options            = options
    end

    def update_title(string)
      @title = string
      self.text_sibblings.each(&:remove)
      el = title_element(string)
      self.element.next = el
      reset
      parse
      title
    end

    def checked=(bool)
      self.element["checked"] = (!!bool).to_s
    end

    def checked
      self.element["checked"] == "true"
    end
    alias :checked? :checked

    def links(href = nil)
      regex = Regexp.new(href) if href
      self.following_siblings.inject([]) do |ary, s|
        match = if href
          s.name == 'a' && regex.match(s['href'])
        else
          s.name == 'a'
        end
        next ary unless match
        ary << Link.new(s, s['href'], s.text)
      end
    end

    def remove_links(href = nil)
      links(href).each { |link| link.element.remove }
      reset
      parse
      links(href)
    end

    def clean_links(href = nil)
      links(href).map do |link|
        if link.element.xpath('.//text()').empty?
          link.element.remove
        end
      end.compact
      reset
      parse
      links(href)
    end

    def linked?(href = nil)
      !links(href).empty?
    end

    def stopped_by_link?
      @stopped_by_link
    end

    def append_link(href, text = '', options = {})
      appender = LinkAppender.new(append_link_point)
      appender.append_link(href, text, options)
      reset
      parse
      self
    end

    private

    def reset
      @title              = ''
      @following_siblings = []
      @stopping_sibling   = nil
      @text_sibblings     = []
    end

    def parse
      Parser.new(self, options).parse
    end

    def append_link_point
      self.text_sibblings.reverse.find { |s| !s.blank? } || self.element
    end

    def title_element(string)
      Nokogiri::XML::Text.new(string, self.element.document)
    end
  end
end

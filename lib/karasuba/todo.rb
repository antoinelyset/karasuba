class Karasuba
  class Todo
    attr_accessor :element, :title, :following_siblings, :stopping_sibling, :text_sibblings

    def initialize(element, title =  '', following_siblings = [], text_sibblings = [])
      @element = element
      @title   = title
      @following_siblings = following_siblings
      @stopping_sibling = nil
      @text_sibblings = text_sibblings
    end

    def update_title(string)
      @title = string
      self.text_sibblings.each(&:remove)
      el = title_element(string)
      self.element.next = el
      self.text_sibblings = [el]
      self.title
    end

    def checked=(bool)
      self.element["checked"] = (!!bool).to_s
    end

    def checked
      self.element["checked"] == "true"
    end

    def checked?
      checked
    end

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
      links(href).each do |link|
        link.element.remove
        self.following_siblings.delete(link.element)
      end
    end

    def clean_links(href = nil)
      links(href).map do |link|
        if link.element.xpath('.//text()').empty?
          link.element.remove
          self.following_siblings.delete(link.element)
        end
      end.compact
    end

    def linked?(href = nil)
      !links(href).empty?
    end

    def append_link(href, text = '', options = {})
      appender = LinkAppender.new(append_link_point || self.element)
      appender.append_link(href, text, options)
    end

    private

    def append_link_point
      self.text_sibblings.reverse.find { |s| !s.blank? }
    end

    def title_element(string)
      Nokogiri::XML::Text.new(string, self.element.document)
    end
  end
end

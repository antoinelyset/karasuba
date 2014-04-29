class Karasuba
  class Todo
    attr_accessor :element, :checked, :title, :links, :following_siblings, :stopping_sibling, :text_sibblings

    def initialize(element, checked = false, title =  '', following_siblings = [], text_sibblings = [])
      @element = element
      @checked = checked
      @title   = title
      @following_siblings = following_siblings
      @stopping_sibling = nil
      @text_sibblings = text_sibblings
    end

    def checked?
      checked
    end

    def links(href = nil)
      regex = Regexp.new(href) if href
      following_siblings.inject([]) do |ary, s|
        match = if href
          s.name == 'a' && regex.match(s['href'])
        else
          s.name == 'a'
        end
        next ary unless match
        ary << Link.new(s, s['href'], s.text)
      end
    end

    def linked?(href = nil)
      !!links(href)
    end

    def append_link(href, text = '')
      appender = LinkAppender.new(append_point)
      appender.append_link(href, text)
    end

    def append_point
      text_sibblings.reverse.find { |s| !s.blank? }
    end
  end
end

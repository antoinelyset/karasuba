class Karasuba
  class Todo
    attr_accessor :checked, :title, :links

    def initialize(checked = false, title =  '', links = [])
      @checked = checked
      @title   = title
      @links   = links
    end

    def checked?
      checked
    end

    def linked?(regex = nil)
      if regex
        !!last_link_matching(regex)
      else
        links.count > 0
      end
    end

    def last_link_matching(regex)
      regex = Regexp.new(regex)
      links.select { |link| regex.match(link.href) }.last
    end
  end
end

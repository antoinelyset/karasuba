class Karasuba
  class Link
    attr_accessor :href, :text, :position

    def initialize(href = '', position = 0, text = '')
      @href     = href
      @text     = text
      @position = position
    end
  end
end

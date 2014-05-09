class Karasuba
  class Link
    attr_accessor :element, :href, :text

    def initialize(element, href = '', text = '')
      @element = element
      @href    = href
      @text    = text
    end
  end
end

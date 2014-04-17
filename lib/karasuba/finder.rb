class Karasuba
  class Finder
    attr_reader :elements
    def initialize(elements)
      @elements = elements
    end

    # Find the text and instanciate the <Todo> element
    #
    # @return [Array<Todo>]
    def todos
      todo_elements.map do |element|
        Todo.new(element)
      end
    end

    private

    def todo_elements
      elements.xpath('//en-todo')
    end
  end
end

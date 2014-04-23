class Karasuba
  class TodoList
    attr_reader :list
    def initialize
      @list = []
    end

    def add(todo)
      @list << todo
    end

    def unlinked_todos(regex = nil)
      @list - linked_todos(regex)
    end

    def linked_todos(regex = nil)
      @list.select do |todo|
        todo.linked?(regex)
      end
    end
  end
end

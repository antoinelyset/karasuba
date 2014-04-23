class Karasuba
  class Finder < Nokogiri::XML::SAX::Document
    attr_reader :todos

    STOPPING_ELEMENTS = ['en-todo', 'br', 'en-note']
    STARTING_ELEMENTS = ['en-todo']

    def initialize
      @todos = TodoList.new
      @in_todo = false
      super
    end

    def start_element(name, attrs = [])
      todo_action(name, attrs)
      link_action(name, attrs, :start)
      @preceding_element = name
    end

    def end_element(name, attrs = [])
      todo_action(name, attrs)
      link_action(name, attrs, :end)
      @preceding_element = name
    end

    def characters(string)
      if @in_link
        @current_link.text << string
      elsif @in_todo
        @current_todo.title << string
      end
      @preceding_element = 'characters'
    end

    def todo_action(name, attrs = [])
      unless name == 'en-todo' && @preceding_element == 'en-todo'
        if stop_and_start_todo?(name)
          stop_and_start_todo(attrs)
        elsif start_todo?(name)
          start_todo(attrs)
        elsif stop_todo?(name)
          stop_todo
        end
      end
    end

    def link_action(name, attrs, state)
      return unless @in_todo && name == 'a'
      state == :start ? start_link(attrs) : stop_link
    end

    def stop_and_start_todo?(name)
      @in_todo == true && name == 'en-todo'
    end

    def start_todo?(name)
      @in_todo == false && STARTING_ELEMENTS.include?(name)
    end

    def stop_todo?(name)
      @in_todo == true && STOPPING_ELEMENTS.include?(name)
    end

    def stop_and_start_todo(attrs)
      stop_todo
      start_todo(attrs)
    end

    def start_todo(attrs = [])
      @in_todo = true
      @current_todo = Todo.new(is_checked?(attrs))
    end

    def stop_todo
      @in_todo = false
      @todos.add(@current_todo)
    end

    def start_link(attrs)
      @in_link = true
      @current_link = Link.new(Hash[attrs]['href'], @current_todo.title.length)
    end

    def stop_link
      @in_link = false
      @current_todo.links << @current_link
    end

    def is_checked?(attrs)
      Hash[attrs]['checked'] == 'true'
    end
  end
end

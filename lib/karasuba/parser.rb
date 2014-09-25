class Karasuba
  class Parser
    STOPPING_ELEMENTS     = ['en-todo', 'br', 'en-note']
    IGNORED_TEXT_ELEMENTS = ['img', 'map', 'table']

    attr_reader :todo

    def initialize(todo_or_element, options = {})
      @todo        = todo_or_element.is_a?(Todo) ? todo_or_element : Todo.new(todo_or_element, '', [], [], options)
      @ignore_link = options[:ignore_link]
      @stop_link   = options[:stop_link]
    end

    def parse
      cursor       = todo.element
      while(cursor = next_element(cursor))
        stop_todo(cursor) && break if stopping_element?(cursor)
        todo.following_siblings << cursor
        if ignore_element?(cursor)
          @ignore_children = true
        else
          if cursor.text?
            todo.text_sibblings << cursor
            todo.title << cursor.text
          end
        end
      end
      todo
    end

    def stop_todo(cursor)
      todo.stopped_by_link  = stop_link?(cursor)
      todo.stopping_sibling = cursor
    end

    def stopping_element?(el)
      STOPPING_ELEMENTS.include?(el.name) || stop_link?(el)
    end

    def ignore_element?(el)
      IGNORED_TEXT_ELEMENTS.include?(el.name) || ignore_link?(el)
    end

    def ignore_link?(el)
      return false unless @ignore_link
      match_href(el, @ignore_link) && match_content(el, @ignore_link)
    end

    def stop_link?(el)
      return false unless @stop_link
      match_href(el, @stop_link) && match_content(el, @stop_link)
    end

    def match_href(el, link_options)
      return true unless link_options[:href]
      if link_options[:href].is_a?(Regexp)
        link_options[:href].match(el['href'])
      else
        link_options[:href] == el['href']
      end
    end

    def match_content(el, link_options)
      return true unless link_options[:content]
      if link_options[:content].is_a?(Regexp)
        link_options[:content].match(el.content)
      else
        link_options[:content] == el.content
      end
    end

    def next_element(cursor)
      if @ignore_children
        @ignore_children = false
        following_element(cursor)
      else
        cursor.children.first || following_element(cursor)
      end
    end

    def following_element(cursor)
      cursor.next || (following_element(cursor.parent) if followable?(cursor))
    end

    def followable?(cursor)
      cursor.parent && !root?(cursor.parent)
    end

    def root?(element)
      element.name == 'en-note'
    end
  end
end

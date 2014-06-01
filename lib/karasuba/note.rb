class Karasuba
  class Note
    attr_reader :xml, :todos

    STOPPING_ELEMENTS     = ['en-todo', 'br', 'en-note']
    IGNORED_TEXT_ELEMENTS = ['img', 'map', 'table']

    def initialize(xml)
      @xml = xml
      @todos = []
      @todo_elements = xml.xpath('//en-todo')
      instanciate_todos
    end

    def instanciate_todos
      @todos = @todo_elements.map { |todo| find_todo(todo) }
    end

    def find_todo(todo_element)
      current_todo = Todo.new(todo_element)
      cursor       = todo_element
      while(cursor = next_element(cursor))
        stop_todo(current_todo, cursor) && break if STOPPING_ELEMENTS.include?(cursor.name)
        current_todo.following_siblings << cursor
        if IGNORED_TEXT_ELEMENTS.include?(cursor.name)
          @ignore_children = true
        else
          if cursor.text?
            current_todo.text_sibblings << cursor
            current_todo.title << cursor.text
          end
        end
      end
      current_todo
    end

    def stop_todo(current_todo, cursor)
      current_todo.stopping_sibling = cursor
      @todos << current_todo
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
      cursor.next || (following_element(cursor.parent) unless is_root?(cursor.parent))
    end

    def is_root?(element)
      element.name == 'en-note'
    end

    def footer?(title)
      self.xml.xpath("//*[attribute::title=\"#{title}\"]").last
    end

    def append_footer(text, options = {})
      appender = FooterAppender.new(append_footer_point)
      appender.append_footer(text, options)
    end

    def equivalent?(doc_or_string)
      doc_or_string = Nokogiri.parse(doc_or_string) if doc_or_string.is_a?(String)
      EquivalentXml.equivalent?(self.xml, doc_or_string, element_order: true, normalize_whitespace: true)
    end

    private

    # TODO Test with empty en-note
    def append_footer_point
      self.xml.xpath('//en-note/child::*[position()=last()]').first
    end
  end
end

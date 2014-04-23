class Karasuba
  class LinkAppender
    attr_reader :todo_list, :xml_parsed

    def initialize(todo, xml)
      @todo_list  = todo_list
      @xml_parsed = xml_parsed
    end

    def append(todo_list, regex = nil)
      todo_list.list.each_with_index do |todo, i|
        todo.linked?(regex)
      end
    end
  end
end

require 'spec_helper'

describe Karasuba::Note do
  describe '#todos' do
    it 'parses the xml to find the todos' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo.enml"))
      expect(Karasuba::Note.new(xml).todos.count).to eq(1)
    end

    it 'parses a blank xml to find the todos' do
      blank_xml = Nokogiri.parse('')
      expect(Karasuba::Note.new(blank_xml).todos.count).to eq(0)
    end

    it 'extracts todos title' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo.enml"))
      expect(Karasuba::Note.new(xml).todos.first.title).to eq('Get Things Done!')
    end

    it 'extracts todos title with style' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_style.enml"))
      expect(Karasuba::Note.new(xml).todos.first.title).to eq('Remember the milk')
    end

    it 'extracts todo even in root node' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_in_root_node.enml"))
      expect(Karasuba::Note.new(xml).todos.first.title).to eq('Get Things Done!')
    end

    it 'extracts multiples todos even in root node' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/todos_in_root_node.enml"))
      expect(Karasuba::Note.new(xml).todos.count).to eq(33)
    end

    it 'extracts text even in link' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_link.enml"))
      expect(Karasuba::Note.new(xml).todos.first.title).to eq('Get Things Done!')
    end

    context 'when ignoring a link' do
      let(:xml) { Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_ignored_link.enml")) }

      it 'doesnt ignore by default' do
        expect(Karasuba::Note.new(xml).todos.first.title).to eq('Get Things Done!>')
      end

      it 'accepts to ignore a link' do
        ignore_link = {href: 'https://app.azendoo.com/#tasks/1234', content: '>'}
        expect(Karasuba::Note.new(xml, ignore_link: ignore_link).todos.first.title).to eq('Get Things Done!')
      end

      it 'accepts to ignore a link and parses the following todos' do
        ignore_link = {href: 'https://app.azendoo.com/#tasks/1234', content: '>'}
        expect(Karasuba::Note.new(xml, ignore_link: ignore_link).todos.count).to eq(2)
      end

      it 'accepts to ignore a link and parses the following title todos' do
        ignore_link = {href: 'https://app.azendoo.com/#tasks/1234', content: '>'}
        expect(Karasuba::Note.new(xml, ignore_link: ignore_link).todos.last.title).to eq('Todo #1')
      end

      it 'accepts to ignore a link with a href regex filter' do
        ignore_link = {href: /app\.azendoo/}
        expect(Karasuba::Note.new(xml, ignore_link: ignore_link).todos.first.title).to eq('Get Things Done!')
      end

      it 'accepts to ignore a link with a content regex filter' do
        ignore_link = {content: />/}
        expect(Karasuba::Note.new(xml, ignore_link: ignore_link).todos.first.title).to eq('Get Things Done!')
      end

      it 'accepts to ignore a link with a content and a href regex filters' do
        ignore_link = {href: 'https://app.azendoo.com/#tasks/1234', content: />/}
        expect(Karasuba::Note.new(xml, ignore_link: ignore_link).todos.first.title).to eq('Get Things Done!')
      end
    end

    context 'when stopping on a link' do
      let(:xml) { Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_ignored_link.enml")) }

      it 'doesnt stop by default' do
        expect(Karasuba::Note.new(xml).todos.first.title).to eq('Get Things Done!>')
      end

      it 'accepts to stop a link' do
        stop_link = {href: 'https://app.azendoo.com/#tasks/1234', content: '>'}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.first.title).to eq('Get Things Done!')
      end

      it 'stops to parse the current todo title' do
        stop_link = {href: /example\./}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.first.title).to eq('Get ')
      end

      it 'accepts to stop a link and parses the following todos' do
        stop_link = {href: 'https://app.azendoo.com/#tasks/1234', content: '>'}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.count).to eq(2)
      end

      it 'accepts to stop a link and parses the following title todos' do
        stop_link = {href: 'https://app.azendoo.com/#tasks/1234', content: '>'}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.last.title).to eq('Todo #1')
      end

      it 'accepts to ignore a link with a href regex filter' do
        stop_link = {href: /app\.azendoo/}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.first.title).to eq('Get Things Done!')
      end

      it 'accepts to ignore a link with a content regex filter' do
        stop_link = {content: />/}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.first.title).to eq('Get Things Done!')
      end

      it 'accepts to ignore a link with a content and a href regex filters' do
        stop_link = {href: 'https://app.azendoo.com/#tasks/1234', content: />/}
        expect(Karasuba::Note.new(xml, stop_link: stop_link).todos.first.title).to eq('Get Things Done!')
      end
    end
  end

  describe '#append_footer' do
    it 'appends to a note with a todo' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo.enml"))
      note = Karasuba::Note.new(xml)
      note.append_footer('A footer')
      expected = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_footer.enml"))
      expect(EquivalentXml.equivalent?(note.xml, expected)).to be_truthy
    end

    it 'appends to an empty note' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/empty_note.enml"))
      note = Karasuba::Note.new(xml)
      note.append_footer('A footer')
      expected = Nokogiri.parse(File.read("#{Support.path}/note/empty_note_with_footer.enml"))
      expect(EquivalentXml.equivalent?(note.xml, expected)).to be_truthy
    end

    it 'appends to a note with multiple todos' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/todos_in_root_node.enml"))
      note = Karasuba::Note.new(xml)
      note.append_footer('A footer')
      expected = Nokogiri.parse(File.read("#{Support.path}/note/todos_in_root_node_with_footer.enml"))
      expect(EquivalentXml.equivalent?(note.xml, expected)).to be_truthy
    end
  end

  describe '#footer?' do
    it 'returns true if there is a footer (tested by title)' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_titled_footer.enml"))
      note = Karasuba::Note.new(xml)
      expect(note.footer?('az-footer')).to be_truthy
    end

    it 'returns false if there is no footer' do
      xml = Nokogiri.parse(File.read("#{Support.path}/note/minimal_todo_with_footer.enml"))
      note = Karasuba::Note.new(xml)
      expect(note.footer?('az-footer')).to be_falsy
    end
  end
end


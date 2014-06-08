require 'spec_helper'

describe Karasuba::Todo do
  context 'for a unlinked todo' do
    let(:content)      { File.read("#{Support.path}/unlinked_todo/base.enml") }
    let(:minimal_todo) { Karasuba.new(content).todos.first }

    it 'parses the title' do
      expect(minimal_todo.title).to eq('Get Things Done!')
    end

    it 'parses the checked status' do
      expect(minimal_todo.checked).to be_falsy
    end

    it 'parses the checked status and alias to checked?' do
      expect(minimal_todo.checked?).to be_falsy
    end

    it 'tests the existence of links' do
      expect(minimal_todo.linked?).to be_falsy
    end

    it 'tests the existence of links with specific href' do
      expect(minimal_todo.linked?('http://azendoo.com')).to be_falsy
    end

    it 'returns the parsed links' do
      expect(minimal_todo.links).to be_empty
    end

    it 'returns the parsed links for specific urls' do
      expect(minimal_todo.links('http://azendoo.com')).to be_empty
    end

    it 'isnt stopped by a link' do
      expect(minimal_todo.stopped_by_link?).to be_falsy
    end

    describe '#append_link' do
      let(:href) { "https://app.azendoo.com/#tasks/1234" }

      it 'appends after the last text sibblings' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        expected = Nokogiri.parse(File.read("#{Support.path}/unlinked_todo/base_with_appended_link.enml"))
        expect(EquivalentXml.equivalent?(todo.element.document, expected)).to be_truthy
      end

      it 'changes de links count' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        expect(todo.links.count).to eq(1)
      end

      it 'changes de links object' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        expect(todo.links.first.text).to eq('>')
      end

      it 'updates the title' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        expect(todo.title).to eq('Get Things Done!>')
      end
    end
  end

  context 'for a linked todo' do
    let(:content) { File.read("#{Support.path}/linked_todo/base.enml") }
    let(:linked_todo) { Karasuba.new(content).todos.first }

    it 'parses the title' do
      expect(linked_todo.title).to eq('Get Things Done!')
    end

    it 'parses the checked status' do
      expect(linked_todo.checked).to be_falsy
    end

    it 'tests the existence of links' do
      expect(linked_todo.linked?).to be_truthy
    end

    it 'tests the existence of links with specific href' do
      expect(linked_todo.linked?('https://azendoo.com')).to be_truthy
    end

    it 'tests the existence of links with specific regex' do
      expect(linked_todo.linked?(/azendoo/)).to be_truthy
    end

    it 'returns the parsed links' do
      expect(linked_todo.links.count).to eq(1)
    end

    it 'returns the parsed links for specific urls' do
      expect(linked_todo.links('https://azendoo.com').count).to eq(1)
    end

    it 'isnt stopped by a link' do
      expect(linked_todo.stopped_by_link?).to be_falsy
    end

    describe '#append_link' do
      let(:href) { "https://app.azendoo.com/#tasks/1234" }

      it 'appends after the last text sibblings' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        # The markup in this note may be not really clean (nested link elements)
        #   but this is valid ENML DTD and it is "healed" by Evernote
        expected = Nokogiri.parse(File.read("#{Support.path}/linked_todo/base_with_appended_link.enml"))
        expect(EquivalentXml.equivalent?(todo.element.document, expected)).to be_truthy
      end

      it 'updates the title' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, ' Azendoo')
        # The markup in this note may be not really clean (nested link elements)
        #   but this is valid ENML DTD and it is "healed" by Evernote
        expect(todo.title).to eq('Get Things Done! Azendoo')
      end

      it 'changes de links count' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        expect(todo.links.count).to eq(2)
      end

      it 'changes de links object' do
        todo = Karasuba.new(content).todos.first
        todo.append_link(href, '>')
        expect(todo.links.last.text).to eq('>')
      end
    end
  end

  context 'for a linked todo with a link ignored' do
    let(:content)     { File.read("#{Support.path}/linked_todo_with_ignored_link/base.enml") }
    let(:linked_todo) { Karasuba.new(content, ignore_link: {href: /azendoo\.com/}).todos.first }

    it 'parses the title' do
      expect(linked_todo.title).to eq('Get Things Done!')
    end

    it 'parses the checked status' do
      expect(linked_todo.checked).to be_falsy
    end

    it 'tests the existence of links' do
      expect(linked_todo.linked?).to be_truthy
    end

    it 'tests the existence of links with specific href' do
      expect(linked_todo.linked?('https://app.azendoo.com')).to be_truthy
    end

    it 'tests the existence of links with specific regex' do
      expect(linked_todo.linked?(/azendoo/)).to be_truthy
    end

    it 'returns the parsed links' do
      expect(linked_todo.links.count).to eq(2)
    end

    it 'returns the parsed links for specific urls' do
      expect(linked_todo.links(/https:\/\/.*\.com/).count).to eq(2)
    end

    it 'isnt stopped by a link' do
      expect(linked_todo.stopped_by_link?).to be_falsy
    end

    describe '#append_link' do
      let(:href)          { "https://app.azendoo.com/#tasks/1234" }
      let(:appended_href) { "https://app.azendoo.com/#tasks/5678" }

      it 'appends after the last text sibblings' do
        todo = Karasuba.new(content, ignore_link: {href: href}).todos.first
        todo.append_link(appended_href, '>')
        expected = Nokogiri.parse(File.read("#{Support.path}/linked_todo_with_ignored_link/base_with_appended_link.enml"))
        expect(EquivalentXml.equivalent?(todo.element.document, expected)).to be_truthy
      end

      it 'updates the title' do
        todo = Karasuba.new(content, ignore_link: {href: href}).todos.first
        todo.append_link(appended_href, ' Azendoo')
        expect(todo.title).to eq('Get Things Done! Azendoo')
      end

      it 'changes de links count' do
        todo = Karasuba.new(content, ignore_link: {href: href}).todos.first
        todo.append_link(appended_href, '>')
        expect(todo.links.count).to eq(3)
      end

      it 'changes de links object' do
        todo = Karasuba.new(content, ignore_link: {href: href}).todos.first
        todo.append_link(appended_href, '>')
        expect(todo.links.last.text).to eq('>')
      end
    end
  end

  context 'for a linked todo with a stopped link' do
    let(:content)     { File.read("#{Support.path}/linked_todo_with_stopped_link/base.enml") }
    let(:linked_todo) { Karasuba.new(content, stop_link: {href: /example\.com/}).todos.first }

    it 'parses the title' do
      expect(linked_todo.title).to eq('Get ')
    end

    it 'parses the checked status' do
      expect(linked_todo.checked).to be_falsy
    end

    it 'doesnt the stopped link in the links' do
      expect(linked_todo.linked?).to be_falsy
    end

    it 'doesnt include the following links' do
      expect(linked_todo.linked?('https://app.azendoo.com')).to be_falsy
    end

    it 'returns the parsed links for specific urls' do
      expect(linked_todo.links(/https:\/\/.*\.com/).count).to eq(0)
    end

    it 'is stopped by a link' do
      expect(linked_todo.stopped_by_link?).to be_truthy
    end

    it 'extracts the stop href' do
      expect(linked_todo.stopping_link.href).to eq('https://example.com')
    end
  end
end

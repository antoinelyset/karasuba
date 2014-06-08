require 'spec_helper'

# This specs are basic actions combine to enable
#   a synchronization with Evernote
describe 'Integrations' do
  let(:link_options)   { {style: 'color: #1e8bc6;', title: 'Synchronized with Azendoo'} }
  let(:footer_options) {
    {
      division_style: 'font-size: 0.9em;',
      horizontal_rule_style: 'background-color: rgb(222, 222, 222); border: 0px; height: 1px;',
      paragraph_style: 'color: #878888; font-style: italic;'
    }
  }
  let(:footer_content) { 'Checkboxes in this note are synced with tasks in Azendoo.<a href="http://help.azendoo.com/knowledgebase/articles/375007"> Learn more.</a>' }

  it 'appends a link and a footer' do
    note = Karasuba.new(File.read("#{Support.path}/integration/minimal_todo.enml")).note
    href = 'https://app.azendoo.com/#tasks/1234'
    note.todos.each { |todo| todo.append_link(href, '>', link_options) }
    note.append_footer(footer_content, title: 'az-footer', style: footer_options)
    expected = Nokogiri.parse(File.read("#{Support.path}/integration/minimal_todo_synced.enml"))
    expect(EquivalentXml.equivalent?(note.xml, expected)).to be_truthy
  end
end

require 'spec_helper'

describe Karasuba do
  let(:content) { File.read("#{Support.path}/note/minimal_todo.enml") }
  describe '#initialize' do
    it 'coerces from an object with a content method' do
      note     = double('note', content: content)
      expected = Nokogiri.parse(content)
      karasuba = Karasuba.new(note)
      expect(EquivalentXml.equivalent?(karasuba.xml, expected)).to be_truthy
    end

    it 'works with a String' do
      expected = Nokogiri.parse(content)
      karasuba = Karasuba.new(content)
      expect(EquivalentXml.equivalent?(karasuba.xml, expected)).to be_truthy
    end
  end
end

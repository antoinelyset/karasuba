require 'spec_helper'

describe Karasuba do
  describe '#initialize' do
    it 'coerces from an object with a content method' do
      minimal_todo = File.read("#{Support.path}/minimal_todo.enml")
      note         = double('note', content: minimal_todo)
      expected     = Nokogiri.parse(minimal_todo)
      # We need to use to_s because XML and equality is hard
      #   this works cause this example is simple
      Karasuba.new(note).parsed.to_s.should eq(expected.to_s)
    end

    it 'works with a String' do
      minimal_todo = File.read("#{Support.path}/minimal_todo.enml")
      expected     = Nokogiri.parse(minimal_todo)
      Karasuba.new(minimal_todo).parsed.to_s.should eq(expected.to_s)
    end
  end
end

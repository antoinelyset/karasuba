# encoding: utf-8
require 'karasuba'

require 'coveralls'
Coveralls.wear!


module Support
  def self.path
    File.expand_path('../support', __FILE__)
  end
end

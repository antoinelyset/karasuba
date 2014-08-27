# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'karasuba/version'

Gem::Specification.new do |s|
  s.name          = "karasuba"
  s.version       = Karasuba::VERSION
  s.authors       = ["antoinelyset"]
  s.email         = ["antoinelyset@gmail.com"]
  s.homepage      = "https://github.com/antoinelyset/karasuba"
  s.summary       = "Evernote is using a subset of XML, called ENML. Karabusa is a parser, a friendly reference to Nokogiri"
  s.description   = "ENML Parser"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.add_runtime_dependency('nokogiri', '> 1.5')
  s.add_runtime_dependency('equivalent-xml', '~> 0.4')

  s.add_development_dependency('bundler', '> 1.3')
  s.add_development_dependency('rake')
end

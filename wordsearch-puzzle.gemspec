lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wordsearch/version"

Gem::Specification.new do |gem|
  gem.version     = WordSearch::Version::STRING
  gem.name        = "wordsearch-puzzle"
  gem.authors     = ["Jamis Buck"]
  gem.email       = ["jamis@jamisbuck.org"]
  gem.homepage    = "http://github.com/jamis/wordsearch"
  gem.summary     = "A word-search puzzle generator, utility and library"
  gem.description = %q{Generates word-search puzzles and emits them to PDF. Customizable.}
  gem.license     = 'CC Attribution 4.0 International'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = "wordsearch"
  gem.require_paths = ["lib"]

  gem.add_dependency "prawn", "~> 2.0", ">= 2.0.0"
end

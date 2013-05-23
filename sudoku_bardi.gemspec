Gem::Specification.new do |s|
  s.name = 'sudoku_bardi'
  s.version = '0.1.0'
  s.date = '2013-05-23'
  s.summary = "Sudoku solver, validator and generator"
  s.description = "sudoku_bardi (see websudoku.com) is a set of tools for solving, validating and generating Sudoku puzzles."

  s.authors = ['Bardi Einarsson']
  s.email = ['bardi@hotmail.com']
  s.homepage = 'https://github.com/bardibardi/sudoku_bardi'
  s.required_ruby_version = '>= 1.9.2'
  s.add_development_dependency('rspec', '~> 2.11')

  s.files = %w(
.gitignore
Gemfile
LICENSE.md
README.md
sudoku_bardi.gemspec
lib/sudoku_bardi.rb
spec/sudoku_bardi_spec.rb
spec/support/no_should_rspec.rb
spec/support/sudoku_bardi_test.rb
spec/support/sudoku_fixture.rb
)
end


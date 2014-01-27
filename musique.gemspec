Gem::Specification.new do |gem|
  gem.name          = "musique"
  gem.version       = "0.0.2"

  gem.required_ruby_version = ">= 1.9.2"

  gem.description   = %q{Musique is a gem for manipulating with musical constructs, such as notes, chords and intervals.}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/janko-m/musique"
  gem.authors       = ["Janko Marohnić"]
  gem.email         = ["janko.marohnic@gmail.com"]

  gem.license       = "MIT"

  gem.files         = Dir["README.md", "LICENSE", "lib/**/*"]
  gem.require_path  = "lib"
end

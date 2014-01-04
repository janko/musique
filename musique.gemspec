lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "musique"
  gem.version       = "0.0.1"

  gem.required_ruby_version = ">= 1.9.2"

  gem.description   = %q{This gem is an object-oriented wrapper for the Flickr API.}
  gem.summary       = gem.description
  gem.homepage      = "http://janko-m.github.com/flickr-objects"
  gem.authors       = ["Janko Marohnić"]
  gem.email         = ["janko.marohnic@gmail.com"]

  gem.license       = "MIT"

  gem.files         = Dir["README.md", "LICENSE", "lib/**/*"]
  gem.require_path  = "lib"
end

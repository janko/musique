require "musique"
require "pry"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect # Force the "expect" syntax
  end

  config.fail_fast = true
end

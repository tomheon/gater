require 'lib/gater'
require 'test/unit'

class GaterTest < Test::Unit::TestCase

  def test_empty_junction
    # just make sure this doesn't blow up
    Gater.known_gates = {}
    Gater.junction do |switcher|
    end
    assert(true)
  end

end

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

  def test_single_default_junction
    val = false
    Gater.known_gates = {}

    Gater.junction do |switcher|
      switcher.branch do
        val = true
      end
    end

    assert(val)
  end

  def test_single_feature_alone()
    Gater.known_gates = {:hello => true}
    val = false

    Gater.junction do |switcher|
      switcher.branch :hello do
        val = true
      end
    end

    assert(val)
    val = false

    Gater.known_gates = {:hello => false}
    Gater.junction do |switcher|
      switcher.branch :hello do
        val = true
      end
    end

    assert(!val)
  end

  def test_single_feature_with_default()
    Gater.known_gates = {:hello => true}
    val = 0

    Gater.junction do |switcher|
      switcher.branch :hello do
        val = 1
      end

      switcher.branch do
        val = 2
      end
    end

    assert_equal(1, val)
    val = 0

    Gater.known_gates = {:hello => false}
    Gater.junction do |switcher|
      switcher.branch :hello do
        val = 1
      end

      switcher.branch do
        val = 2
      end
    end

    assert_equal(2, val)
  end

  def test_switcher_handles_strings_and_symbols
    [['hello', 'hello'], ['hello', :hello], [:hello, 'hello'], [:hello, :hello]].each do |combo|
      gate_key = combo[0]
      switch_key = combo[1]

      Gater.known_gates = {gate_key => true}
      val = false

      Gater.junction do |switcher|

        switcher.branch switch_key do
          val = true
        end

      end

      assert(val)
    end
  end

end

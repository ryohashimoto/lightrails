require "test/unit"
require_relative "../lib/active_representer/base.rb"

class BaseTest < Test::Unit::TestCase
  test ".wrap does not raise error" do
    wrapped = {}
    assert_nothing_raised { ActiveRepresenter::Base.wrap(wrapped) }
  end

  test "#wrapped returns original wrapped object" do
    wrapped = {}
    representer = ActiveRepresenter::Base.wrap(wrapped)
    assert_equal(representer.wrapped, wrapped)
  end
end

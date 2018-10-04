require "test/unit"
require "activerepresenter"

class BaseTest < Test::Unit::TestCase
  test ".new does not raise error" do
    wrapped = {}
    assert_nothing_raised { ActiveRepresenter::Base.new(wrapped) }
  end

  test "#wrapped returns original wrapped object" do
    wrapped = {}
    representer = ActiveRepresenter::Base.new(wrapped)
    assert_equal(representer.wrapped, wrapped)
  end
end

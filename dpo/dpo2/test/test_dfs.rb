require_relative '../lib/graph'

class Test_DFS < Test::Unit::TestCase
  def test_dfs
    expected = (Graph.new(DFS.new, 4)).go_through_graph
    assert_equal expected, [0, 1, 3, 2]
  end
end
require_relative 'Iterator'

class IteratorInOrder < Iterator

  def initialize(root)
    super(root)

    @root = root

    build_order
  end

  def build_order
    @array = @root.getInOrder
  end

end
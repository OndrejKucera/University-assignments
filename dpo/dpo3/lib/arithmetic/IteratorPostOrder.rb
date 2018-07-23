require_relative 'Iterator'

class IteratorPostOrder < Iterator

  def initialize(root)
    super(root)

    @root = root

    build_order
  end

  def build_order
    @array = @root.getPostOrder
  end

end
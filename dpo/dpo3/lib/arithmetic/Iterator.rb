class Iterator

  def initialize(root)
    @root = root
    @array = []
  end


  def next
    @array.shift
  end


  def hasNext
    if @array[0]
      true
    else
      false
    end
  end
end
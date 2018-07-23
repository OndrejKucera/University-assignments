class Player

  attr_accessor :location, :bag_of_items, :name

  def initialize
    @name = ""
    @bag_of_items = []
    @location = nil
  end

end
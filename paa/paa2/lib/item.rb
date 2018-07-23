class Item
  def initialize(array)
    @states = array
    @path_of_rules = []
  end

  def get_state
    @states
  end

  def get_bottle(index)
    @states[index].to_i
  end

  def set_bottle(index, value)
    @states[index] = value
  end

  def get_path
    @path_of_rules
  end

  def length
    @states.length
  end

  def push_path(operation)
    @path_of_rules.push(operation)
  end

  def equal?(item)
    (0..(item.length-1)).each { |index_bottle|
      if item[index_bottle] != self.get_bottle(index_bottle)
        return false
      end
    }
    true
  end

  def cost_function(final_state, capacity)
    cost = 0
    length_of_array = final_state.length-1

    (0..length_of_array).each { |index_bottle|
      if final_state[index_bottle] == self.get_bottle(index_bottle) && self.get_bottle(index_bottle) != 0 && self.get_bottle(index_bottle) != capacity[index_bottle]
        cost += 2
      else
        (0..length_of_array).each { |index|
          if final_state[index_bottle] == self.get_bottle(index) && self.get_bottle(index) != 0 && self.get_bottle(index) != capacity[index]
            cost += 1
            break
          end
        }
      end
    }
    cost
  end

end
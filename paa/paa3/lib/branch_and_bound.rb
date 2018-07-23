require_relative "algorithm"

class Branch_and_bound < Algorithm

  def solve_problem(problem)
    id = problem[0]
    count_of_things = problem[1].to_i
    max_weight = problem[2].to_i
    list_of_things = Array.new

    optimum = 0
    price_of_optimum = 0

    # Load items
    (0..(count_of_things*2-1)).each do |index|
      # Warning! items are load reversed => [price, weight]
      list_of_things.unshift(problem[index+3].to_i)
    end

    # Initialize
    mask = 1
    open = Array.new
    open.push(0)

    count_of_things.times do |index|

      temp_open = []

      price_in_future = 0
      (index+1..count_of_things-1).each do |index_j|
        price_in_future += list_of_things[index_j*2]
      end

      until open.empty?
        item = open.pop

        # generate new item
        new_item = item
        # count weight
        pack = 0
        price = 0
        mask_inner = 1
        (0..index).each do |index_j|
          d = new_item & mask_inner
          if d != 0
            pack += list_of_things[index_j*2+1]
            price += list_of_things[index_j*2]
          end
          mask_inner = mask_inner << 1
        end

        if pack < max_weight
          if price_of_optimum < (price + price_in_future)
            temp_open.push(new_item)

            if price_of_optimum < price
              price_of_optimum = price
              optimum = new_item
            end
          end
        end


        # generate new item
        new_item = item | mask
        # count weight
        pack = 0
        price = 0
        mask_inner = 1
        (0..index).each do |index_j|
          d = new_item & mask_inner
          if d != 0
            pack += list_of_things[index_j*2+1]
            price += list_of_things[index_j*2]
          end
          mask_inner = mask_inner << 1
        end

        if pack < max_weight
          if price_of_optimum < (price + price_in_future)
            temp_open.push(new_item)

            if price_of_optimum < price
              price_of_optimum = price
              optimum = new_item
            end
          end
        end
      end

      open = temp_open
      mask = mask << 1
    end

    result = ""
    mask = 1
    mask = mask << (count_of_things-1)
    (0..count_of_things-1).each do
      d = optimum & mask
      if d != 0
        result += "1"
      else
        result += "0"
      end
      mask = mask >> 1
    end

    [id, count_of_things, price_of_optimum, result]
  end
end
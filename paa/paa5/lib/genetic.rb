require_relative "algorithm"

class Genetic < Algorithm

  def solve_problem(problem)
    @id = problem[0]
    @count_of_things = problem[1].to_i
    @max_weight = problem[2].to_i
    @list_of_things = []

    # Parameters
    @size_population = 40
    @count_cycle = 100
    @size_tournament = 4
    @count_of_alive = 2
    @probability_mutation = 0.1

    # Load items
    (0..(@count_of_things*2-1)).each do |index|
      @list_of_things.push(problem[index+3].to_i) # [weight, price]
    end

    # Initialization population
    population = initialize_population(@size_population)

    @count_cycle.times do

      # Selection
      new_population = selection(population)

      #Mutation
      new_population = mutation(new_population)

      # Add from old population
      temp_population = []
      population.each do |individual|
        if is_criterion?(individual[1])
          temp_population.push(individual)
        end
      end
      best_two = best_from_population(temp_population, 2)
      new_population.push(best_two[0][1])
      new_population.push(best_two[1][1])

      # Form new population is getting actual
      population = []
      new_population.each do |individual|
        population.push([fitness(individual),individual])
      end
    end

    # Get result
    result_population = []
    population.each do |individual|
      if is_criterion?(individual[1])
        result_population.push(individual)
      end
    end
    optimum = best_from_population(result_population,1)

    [@id, @count_of_things, optimum[0][0], optimum[0][1]]
  end


  def mutation(population)
    population.each do |individual|
      if rand > @probability_mutation
        point = rand(@count_of_things)
        if individual[point] == "0"
          individual[point] = "1"
        else
          individual[point] = "0"
        end
      end
    end
  end


  def selection(population)
    selection = []
    population.each do |individual|
      if is_criterion?(individual[1])
        selection.push(individual)
      end
    end

    selection = selection.sort_by { |individual| [individual[0]] }

    new_population = []
    # Tournaments
    ((@size_population-@count_of_alive)/2).times do

      sub_population = []
      chose = []
      @size_tournament.times do
        loop do
          index = rand(selection.size)
          if !chose.include?(index)
            chose.push(index)
            sub_population.push(selection[index])
            break
          end
        end
      end

      parents = tournament(sub_population)

      # Crossing
      children = cross(parents)

      new_population.push(children[0])
      new_population.push(children[1])
    end

    new_population
  end


  def cross(parents)
    point = rand(@count_of_things)

    p1 = parents[0][1][0..point]
    p2 = parents[0][1][point+1..@count_of_things]
    p3 = parents[1][1][0..point]
    p4 = parents[1][1][point+1..@count_of_things]

    [p1+p4,p3+p2]
  end


  def tournament(sub_population)
    best_from_population(sub_population, 2)
  end


  def best_from_population(population, how_many)
    population = population.sort_by{ |individual| [individual[0]]}.reverse!

    result = []
    (0..how_many-1).each do  |index|
      result.push(population[index])
    end

    result
  end


  def initialize_population(size_population)
    population = []

    # Load items
    list = []
    (0...@count_of_things).each do |index|
      weight = @list_of_things[index*2].to_i
      price  = @list_of_things[index*2+1].to_i
      sum = price.to_f/weight.to_f
      order = index
      list.push([weight, price, sum.to_f, order])
    end

    # Sort things
    list = list.sort_by{ |x| [x[2],x[1]]}.reverse!

    # Generation
    size_population.times do
      count_bits = 1 + 5 + rand(25)
      places_in_individual = []
      pack = 0
      list_result = []

      count_bits.times do
        places_in_individual.push(rand(@count_of_things))
      end

      list.each_with_index do |item, index|
        if (!places_in_individual.include?(index)) && (@max_weight >= pack + item[0])
          pack += item[0]
          list_result.push(item[3])
        end
      end

      result = ""
      (0...@count_of_things).each do  |index|
        if list_result.include?(index)
          result << "1"
        else
          result << "0"
        end
      end

      population.push([fitness(result),result])
    end

    population
  end


  def fitness(individual)
    price = 0
    (0...individual.size).each do |index|
      if individual[index] == "1"
       price +=  @list_of_things[index*2+1]
      end
    end

    price
  end


  def is_criterion?(individual)
    weight = 0
    (0...individual.size).each do |index|
      if individual[index] == "1"
        weight += @list_of_things[index*2]
      end
    end

    weight <= @max_weight ? true : false
  end
end
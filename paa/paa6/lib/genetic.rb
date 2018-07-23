  require_relative "algorithm"

class Genetic < Algorithm

  def solve_problem(problem)

    # Load parameters
    @problem = problem
    @count_of_variables = problem[0].to_i
    @count_of_clause = problem[1].to_i
    @weight = [1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5,1,2,3,4,5]

    # Set Parameters
    @size_population = 50+1             # for 120 clause
    @count_cycle = @count_of_clause * 2    # id depends on count of clause

    # Parameters for elitism
    @count_of_alive = 1

    # Parameters for mutation
    @probability_mutation = 0.01 #1.0/@count_of_variables.to_f

    # Parameters for crossover
    @probability_crossover = 0.8
    @size_tournament = 5

    # Parameters for penalty
    @penalty_similarities = 0.05
    @number_bits_for_penalty = 2



    # Initialization population
    population = initialize_population(@size_population)

    i = 0

    @count_cycle.times do
      sort_population = population.sort_by{ |individual| [individual[1]] }

      new_population = []

      ((@size_population-@count_of_alive)/2).times do
        # Selection
        parents = selection(sort_population)

        # Crossover
        children = crossover(parents)

        # Add children to new population
        new_population += children
      end

      # Mutation
      new_population2 = []
      new_population.each do |individual|
        new_population2.push([mutation(individual), 0])
      end

      # Add best individual from old population
      best_older = best_from_population(sort_population, @count_of_alive)
      new_population2.push([best_older[0][0], 0])

      # Form new population is getting actual
      population = []
      new_population2.each_with_index do |individual, index|
        population.push([individual[0], fitness(individual[0], new_population2, index)])
      end

      i += 1

    end

    # Choose best individual
    best = best_from_population(population, 1)

    [best[0][0], best[0][1], get_number_true_clauses(best[0][0]), get_weight(best[0][0])]
  end


  def selection(population)
    parents = []
    last_winner = -1  # -1 means there is no winner yet

    2.times do
      sub_population = []
      is_chosen = []
      @size_tournament.times do
        loop do
          index = rand(population.size)
          if !is_chosen.include?(index) && (index != last_winner)
            is_chosen.push(index)
            sub_population.push(population[index])
            break
          end
        end
      end

      # Tournament
      winner_of_tournament = tournament(sub_population)
      parents.push(winner_of_tournament)

      # Remember winner
      last_winner = is_chosen[sub_population.find_index(winner_of_tournament)]
    end

    parents
  end


  def crossover(parents)
    if rand < @probability_crossover

      type_of_crossover = rand(2)

      # One point crossover
      if type_of_crossover == 1
        point = rand(@count_of_variables)

        p1begin = parents[0][0][0..point]
        p1end = parents[0][0][point+1..@count_of_variables]
        p2begin = parents[1][0][0..point]
        p2end = parents[1][0][point+1..@count_of_variables]

        child1 = p1begin+p2end
        child2 = p2begin+p1end

      # Two point crossover
      else
        point1 = rand(@count_of_variables)
        point2 = 0
        loop do
          point2 = rand(@count_of_variables)
          if point2 != point1
            if point2 < point1
               tmp = point1
               point1 = point2
               point2 = tmp
            end
            break
          end
        end

        p1begin = parents[0][0][0..point1]
        p1center = parents[0][0][point1+1..point2]
        p1end = parents[0][0][point2+1..@count_of_variables]

        p2begin = parents[1][0][0..point1]
        p2center = parents[1][0][point1+1..point2]
        p2end = parents[1][0][point2+1..@count_of_variables]

        child1 = p1begin + p2center + p1end
        child2 = p2begin + p1center + p2end
      end

    else
      child1 = parents[0][0]
      child2 = parents[1][0]
    end


    [child1, child2]
  end


  def mutation(individual)
    type_of_mutation = rand(2)

    # Replacement mutation
    if type_of_mutation == 1
      (0...individual.size).each do |index|
        if rand < @probability_mutation
          if individual[index] == "0"
            individual[index] = "1"
          else
            individual[index] = "0"
          end
        end
      end

    # Random-swap mutation
    elsif type_of_mutation == 0
      (0...individual.size).each do |index1|
        if rand < @probability_mutation
          # Choose second different gens
          index2 = 0
          loop do
            index2 = rand(@count_of_variables)
            if index2 != index1
              break
            end
          end

          # Change gen
          temp = individual[index1]
          individual[index1] = individual[index2]
          individual[index2] = temp
        end
      end
    end

    individual
  end


  def tournament(sub_population)
    best_from_population(sub_population, 1)[0]
  end


  def best_from_population(population, how_many)
    population = population.sort_by{ |individual| [individual[1]]}.reverse!

    result = []
    (0..how_many-1).each do  |index|
      result.push(population[index])
    end

    result
  end


  def initialize_population(size_population)
    population = []

    size_population.times do
      individual = ""
      (0...@count_of_variables).each do
        individual += rand(2).to_s
      end

      population.push([individual, 0])
    end

    population.each_with_index do |individual, index|
      fitness =  fitness(individual[0], population, index)
      population[index][1] = fitness
    end

    population
  end


  def fitness(individual, population, index)

    # Fitness form clauses
    true_clauses = get_number_true_clauses(individual)

    # Penalty because of similarities
    penalty = 0
    population.each_with_index do |from_population, index_population|
      if hamming_distance(individual,from_population[0], @number_bits_for_penalty) && (index != index_population)
        penalty = @penalty_similarities
        break
      end
    end

    # Weight
    weight = 0
    if true_clauses == @count_of_clause
      weight = get_weight(individual)
    end

    (true_clauses.to_f/@count_of_clause.to_f) - penalty + weight
  end


  def get_number_true_clauses(individual)
    true_clauses = 0

    (2...@count_of_clause+2).each do |index|
      @problem[index].each do |literal|
        # Positive literal
        if literal[1]
          if individual[literal[0]-1] == "1"
            true_clauses += 1
            break
          end

        # Negative literal
        else
          if individual[literal[0]-1] == "0"
            true_clauses += 1
            break
          end
        end
      end
    end

    true_clauses
  end


  def get_weight(individual)
    weight = 0

    (0..individual.size).each do |index|
      if individual[index] == "1"
        weight += @weight[index].to_i
      end
    end

    weight
  end


  def hamming_distance(individual_a, individual_b, max_tolerate)
    distance = 0
    (0..individual_a.size).each do |index|
      if individual_a[index] != individual_b[index]
        if (distance += 1) > max_tolerate
          return false
        end
      end
    end

    true
  end

end
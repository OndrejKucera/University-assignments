require_relative "brute_force"
require_relative "branch_and_bound"
require_relative "dynamic_programming"
require_relative "fptas"
require_relative "greedy_search"

require_relative "reverse_branch_and_bound"
require_relative "reverse_dynamic_programming"
require_relative "reverse_fptas"

class Main

  def initialize
    #@strategy = Brute_force.new()
    #@strategy = Branch_and_bound.new()
    #@strategy = Dynamic_programming.new()
    @strategy = Fptas.new()
    #@strategy = Greedy_search.new()

    #@strategy = Reverse_branch_and_bound.new()
    #@strategy = Reverse_dynamic_programming.new()
    #@strategy = Reverse_fptas.new()

    dir_name = File.dirname(__FILE__)
    dir_name.slice!('lib')

    @dyn = []

    Dir[dir_name + 'data120.txt/instance1/*.dat'].each do |name_file|

      #itera = 0

      @problems = load_problem(name_file)

      @problems.each do |problem|
        t1 = Time.now
        result = solve_problem(problem)
        t2 = Time.now

        puts "#{result[0]} #{result[1]} #{result[2]} #{result[3]} || #{result[4]}"
        puts "CAS = #{(t2 - t1) * 1000.0}"

        #itera += result[4]
        #@dyn.push(result[2])
      end
      #puts "#{name_file} = #{itera / 50}"
    end

=begin
    @greedy = []
    @strategy = Greedy_search.new()
    Dir[dir_name + 'instance5/test1*.dat'].each do |name_file|
      @problems = load_problem(name_file)
      @problems.each do |problem|
        result = solve_problem(problem)
        #puts "#{result[2]}"
        @greedy.push(result[2])
      end
      puts "XXXX#{name_file}"
    end

    @ft = []
    @strategy = Fptas.new()
    Dir[dir_name + 'instance5/test1*.dat'].each do |name_file|
      @problems = load_problem(name_file)
      @problems.each do |problem|
        result = solve_problem(problem)
        #puts "#{result[2]}"
        @ft.push(result[2])
      end
      puts "YYYy#{name_file}"
    end

    soucet = 0
    for x in 0..5
      (0..49).each { |index|
        soucet += (@dyn[x*50+index].to_f-@greedy[x*50+index].to_f)/@dyn[x*50+index].to_f
        #puts "=(#{@dyn[x*50+index].to_f}-#{@greedy[x*50+index].to_f})/#{@dyn[x*50+index].to_f}"
      }
      puts "greedy = #{soucet/50.to_f}"
      soucet = 0
    end

    for x in 0..5
      (0..49).each { |index|
        soucet += (@dyn[x*50+index].to_f-@ft[x*50+index].to_f)/@dyn[x*50+index].to_f
        #puts "=(#{@dyn[x*50+index].to_f}-#{@ft[x*50+index].to_f})/#{@dyn[x*50+index].to_f}"
      }
      puts "ft = #{soucet/50.to_f}"
      soucet = 0
    end
=end
  end


  def load_problem(name_file)
    array_of_problems = Array.new

    File.open(name_file).readlines.each do |input_line|
      input_line = input_line.chomp.split
      array_of_problems.push(input_line)
    end

    array_of_problems
  end


  def solve_problem(problem)
    @strategy.solve_problem(problem)
  end

end
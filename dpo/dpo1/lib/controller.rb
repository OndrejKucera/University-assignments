require_relative "view"
require_relative "model"
require_relative "command"

class Controller
  
  attr_reader :model, :view

  def initialize
    @model = Model.new
    @view = View.new
    @commander_crate = Commander_crate.new(@model, @view)
  end
   
  def start_game
    @view.clear_screen
    @view.output("Welcome to game")
    @view.output("Please insert name of player:")

    if @model.start_game(@view.input)
      @view.clear_screen
      @view.output("Welcome #{@model.name}")
      @view.output("Keep in your mind! Whenever you type 'exit' it will cause game over.")

      @view.output("Are you ready to start game? Y/N")
      while (text = input.capitalize)
        case text
          when "Y"
            @view.clear_screen
            sentence = @model.where_is_player
            (0..sentence.size-1).each { |i|
              puts "#{sentence[i]}"
            }

            while (text = input.capitalize)
              if text.to_i < sentence.size
                sentence = sentence[text.to_i].split
                if sentence[2] == "Jdi"
                  door =  @model.get_door(sentence[5])

                  @commander_crate.command = Command_Go_to.new
                  command_go_to = Commander.new(@commander_crate)

                  if command_go_to.on_execute(door)
                    @view.output("Prosli jsme dvermi")
                  else
                    @view.output("Dvere jsou zamcene")
                  end
                elsif sentence[2] == "Vezmi"
                  item =  @model.get_item(sentence[3])
                  @commander_crate.command = Command_Pick_up.new
                  command_go_to = Commander.new(@commander_crate)

                  if command_go_to.on_execute(item)
                    @view.output("Vzal jsi vec")
                  else
                    @view.output("Nevzal jsi vec")
                  end

                elsif sentence[2] == "Promluv"
                  person =  @model.get_person(sentence[3])
                  @commander_crate.command = Command_Talk.new
                  command_go_to = Commander.new(@commander_crate)

                  command_go_to.on_execute(person)

                elsif sentence[2] == "Pouzij"
                  item =  @model.get_item_from_bag(sentence[3])
                  @commander_crate.command = Command_Use.new
                  command_go_to = Commander.new(@commander_crate)

                  if command_go_to.on_execute(item)
                    @view.output("Vec byla pouzita")
                  else
                    @view.output("Zde nema vyznam pouzit tuto vec")
                  end


                elsif sentence[2] == "Poloz"
                  item =  @model.get_item_from_bag(sentence[3])
                  @commander_crate.command = Command_Put_down.new
                  command_go_to = Commander.new(@commander_crate)

                  if command_go_to.on_execute(item)
                    @view.output("Vec byla polozena")
                  else
                    @view.output("Vec nelze polozit")
                  end

                elsif
                  @view.ouput("Zadejte cislo")
                end

                sentence = @model.where_is_player
                (0..sentence.size-1).each { |i|
                  puts "#{sentence[i]}"
                }
              end
            end
            return
          when "N"
            @view.output("Really? And now?")
          else
            @view.output("Wrong input. Try again.")
        end
      end
    else
      @view.output("Game can't be created.")
    end
  end


  def input
    input = @view.input
    if input == "exit"
      end_game
    end
    input
  end
  
  def end_game
    @view.clear_screen
    @view.output("GAME OVER")
    exit 0
  end

end
require_relative 'model'
require_relative 'hash'

#
#   Input format condition:
#       1) instance of class Room - means that Player must be in this input Room 
#       2) instance of class Item - means that Player must have in his bag of item this input Item
#       3) instance of class Hash - means that World.variables_environment must include this input Hash
#             Every Item has hardcoded conditions: (je to tam natvrdo v konstruktoru)
#                 able_pick_up
#                 able_use
#             Every Door has hardcoded conditions: (je to tam natvrdo v konstruktoru)
#                 able_pass_door
#
class Condition
  def initialize(model, cond = nil)
    @model = model
    if ( @model.instance_of?(Model) == false )
      raise 'Jako parametr konstruktoru se musi predat odkaz na instanci Modelu'
    end
    @envVarsMustBeSet = {}
    @playerMustBeInRoom = nil
    @playerMustHaveItems = []
      
    if cond != nil
      add_condition(cond)
    end
  end

  def add_condition(cond)
    if ( cond.instance_of?(Room) )
      @playerMustBeInRoom = cond
    elsif ( cond.instance_of?(Item) )
      @playerMustHaveItems.push(cond)
    elsif ( cond.instance_of?(Hash) )
      @envVarsMustBeSet.merge!(cond)
    else
      raise 'Nevyhovujici format podminky'  # Mrkni nahoru na zacatek teto tridy na vysvetlujici komentar
    end
  end

  def is_passed?
    if @playerMustBeInRoom != nil && @model.player.location != @playerMustBeInRoom
      return false
    end
    if @envVarsMustBeSet.empty? == false && @model.world.variables_environment.deep_include?( @envVarsMustBeSet ) == false
      return false
    end
    if @playerMustHaveItems.empty? == false && (@playerMustHaveItems - @model.player.bag_of_items).empty? == false
      return false
    end
    return true
  end
  
  def info
    ret = "Condition: "
    if @playerMustBeInRoom != nil
      ret << "Player must be in room '" << @playerMustBeInRoom.name() << "', "
    end
    if @envVarsMustBeSet.empty? == false
      ret << "Variables Environment: " << @envVarsMustBeSet.to_s << ", "
    end
    if @playerMustHaveItems.empty? == false
      ret << "Player must have in bag:"
      @playerMustHaveItems.each{|x| ret << " #{x.name()}" }
    end
    return ret
  end
end

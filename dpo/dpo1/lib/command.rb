
# přepravka pro třídu Commander
class Commander_crate
  attr_accessor :model, :view, :command

  def initialize(model = nil, view = nil, command = nil)
    @model = model
    @view = view
    @command = command
  end
end

class Commander
  attr_accessor :command

  def initialize(commander_crate)
    @command = commander_crate.command
    @command.model = commander_crate.model
    @command.view = commander_crate.view
  end

  def on_execute
    @command.execute if @command
  end
  
  def on_execute(attribute)
    @command.execute(attribute) if @command
  end  
end

module ICommand 
  attr_accessor :model
  attr_accessor :view
end

class Command_Go_to
  include ICommand
  def execute(door)
    if door.hash_conditions['able_pass_door'].is_passed?
      @model.player.location = door.to_room
      #@view.rb.output("You go to " + door.to_room.name)
      return true
    end
    #@view.rb.output("You cannot go to " + door.to_room.name)
    return false
  end
end

class Command_Pick_up
  include ICommand
  def execute(item)
    if item.hash_conditions['able_pick_up'].is_passed?
      @model.player.bag_of_items.push(item)
      @model.player.location.array_items.delete(item)
      #@view.rb.output("You pick up " + item.name)
      return true
    end
    #@view.rb.output("You cannot pick up " + item.name)
    return false
  end
end

class Command_Put_down
  include ICommand
  def execute(item)
    @model.player.location.array_items.push(item)
    @model.player.bag_of_items.delete(item)
    #@view.rb.output("You put down " + item.name)
    return true
  end
end
  
class Command_Talk
  include ICommand
  def execute(person)
    @view.output(person.talk())
    return true
  end
end

class Command_Use
  include ICommand
  def execute(item)
    if item.hash_conditions['able_use'].is_passed?
      #@model.player.bag_of_items.delete(item)
      return true
    end
    return false
  end
end
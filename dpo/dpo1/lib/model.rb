require_relative "player"
require_relative "world"

class Model

  attr_reader :player, :world
  
  def initialize
    @player = Player.new
    @world = World.new(self)
  end

  def start_game(name)
    @player.name = name
    @world.build_all()
    @player.location = @world.hash_rooms["Predsin"]
    true
  end

  def where_is_player
    sentences = Array.new
    sentences[0] = "Jste v mistnosti #{@player.location.name}. Zadejte cislo pro aktivitu:"

    items = @player.location.array_items
    (0..items.size-1).each { |i|
      sentences[i+1] = "[#{i+1}] => Vezmi #{items[i].name}"
    }

    items_in_bag = @player.bag_of_items
    (0..items_in_bag.size-1).each { |i|
      sentences[sentences.size] = "[#{sentences.size}] => Pouzij #{items_in_bag[i].name}"
    }

    items_in_bag = @player.bag_of_items
    (0..items_in_bag.size-1).each { |i|
      sentences[sentences.size] = "[#{sentences.size}] => Poloz #{items_in_bag[i].name}"
    }

    people = @player.location.array_people
    (0..people.size-1).each { |i|
      sentences[sentences.size] = "[#{sentences.size}] => Promluv #{people[i].name}"
    }

    doors = @player.location.array_doors
    (0..doors.size-1).each { |i|
      sentences[sentences.size] = "[#{sentences.size}] => Jdi do pokoje #{doors[i].to_room.name}"
    }

    sentences
  end

  def get_door(to_room)
    doors = @player.location.array_doors

    (0..doors.size-1).each { |i|
      if doors[i].to_room.name == to_room
        return doors[i]
      end
    }
  end


  def get_item(item)
    items = @player.location.array_items

    (0..items.size-1).each { |i|
      if items[i].name == item
        return items[i]
      end
    }
  end


  def get_item_from_bag(item)
    items = @player.bag_of_items

    (0..items.size-1).each { |i|
      if items[i].name == item
        return items[i]
      end
    }
  end


  def get_person(name)
    persons = @player.location.array_people

    (0..persons.size-1).each { |i|
      if persons[i].name == name
        return persons[i]
      end
    }
  end

  def name
    @player.name
  end
end
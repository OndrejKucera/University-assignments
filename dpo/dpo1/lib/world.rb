require_relative 'build_world'

class World

  attr_accessor :variables_environment, :hash_rooms
  
  def initialize(model)
    @model = model
    @hash_rooms = {}            # ({'jeskyne' => Room.new('Jeskyně'), 'vychod_jeskyne' => Room.new()})
    @variables_environment = {} # ({'presvedcil_jsem_jiz_kneze_aby_mi_otevrel_branu' => false})
  end
  
  def build_all
    @build_world = Build_world.new(@model)

    room1 = @build_world.build_room("Predsin")
    room2 = @build_world.build_room("Kuchyn")
    room3 = @build_world.build_room("Obyvaci_pokoj")
    room4 = @build_world.build_room("Pracovna")

    zapalovac = @build_world.build_item_in_room(room1, "zapalovac")
    door_1_2 = @build_world.build_door_in_room(room1, room2) #Hash['able_pass_door' => true])
    door_1_3 = @build_world.build_door_in_room(room1, room3)


    trouba = @build_world.build_item_in_room(room2, "Trouba")
    kucharka = @build_world.build_person_in_room(room2, "kucharka", "Utika plyn!!!")
    door_2_1 = @build_world.build_door_in_room(room2, room1)
    door_2_3 = @build_world.build_door_in_room(room2, room3)

    klic = @build_world.build_item_in_room(room3, "klic")
    @build_world.build_condition(klic, 'able_use', room3)
    door_3_1 = @build_world.build_door_in_room(room3, room1)
    door_3_2 = @build_world.build_door_in_room(room3, room2)

    door_3_4 = @build_world.build_door_in_room(room3, room4)
    @build_world.build_condition(door_3_4, 'able_pass_door', klic)

    hasici_pris = @build_world.build_item_in_room(room4, "hasici pristroj")
    door_4_3 = @build_world.build_door_in_room(room4, room3)


    @hash_rooms["Predsin"] = room1
    @hash_rooms["Kuchyn"] = room2
    @hash_rooms["Pokoj"] = room3
    @hash_rooms["Pracovna"] = room4
  end

end
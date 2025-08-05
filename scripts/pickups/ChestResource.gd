extends Pickups
class_name Chest

func activate():
    #super.activate()
    player_reference.open_chest()
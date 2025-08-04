extends Pickups
class_name Gem

@export var XP: float

func activate():
    super.activate()
    player_reference.gain_XP(XP)
extends PanelContainer

@export var item: PassiveItem:
    set(value):
        item = value
        $TextureRect.texture = value.icon

func _ready():
    if item != null:
        item.player_reference = owner
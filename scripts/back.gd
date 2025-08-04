extends Button

func _ready():
    visible = false

func _process(_delta):
    if get_tree().paused and owner.health <= 0 and not visible:
        visible = true

func _on_pressed():
    get_tree().paused = false
    SaveData.gold += owner.gold
    SaveData.set_and_save()
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
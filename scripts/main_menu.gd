extends Control

func _ready():
    menu()

#TODO: Decide if the start button should have functionality within this script, or in its own script
func _on_upgrades_pressed():
    skill_tree()

func _on_bestiary_pressed():
    bestiary()

func menu():
    $Menu.show()
    $SkillTree.hide()
    $Bestiary.hide()
    $Gold.hide()
    $Back.hide()
    tween_pop($Menu)

func skill_tree():
    $SkillTree.show()
    $Gold.show()
    $Menu.hide()
    $Back.show()
    tween_pop($SkillTree)

func bestiary():
    $Bestiary.show()
    $Gold.hide()
    $Menu.hide()
    $Back.show()
    tween_pop($Bestiary)

func _on_back_pressed():
    menu()

func tween_pop(panel):
    SoundManager.play_sfx(load("res://assets/sfx/POP Brust 01.wav"))
    panel.scale = Vector2(0.85, 0.85)
    var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween.tween_property(panel, "scale", Vector2(1, 1), 0.5)
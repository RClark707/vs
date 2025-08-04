extends VBoxContainer

@export var weapons: HBoxContainer
@export var passive_items: HBoxContainer
var OptionSlot = preload("res://scenes/option_slot.tscn")

@export var particles: GPUParticles2D
@export var panel: NinePatchRect

func _ready():
    hide()
    particles.hide()
    panel.hide()

func close_option():
    hide()
    particles.hide()
    panel.hide()
    get_tree().paused = false

func get_available_resource_in(items_container) -> Array[Item]:
    var resources: Array[Item] = []
    for slot in items_container.get_children():
        if slot.item != null:
            resources.append(slot.item)
    return resources

func add_option(item) -> int:
    if item.is_upgradable():
        var option_slot = OptionSlot.instantiate()
        option_slot.item = item
        add_child(option_slot)
        return 1
    return 0

func show_option():
    var weapons_available = get_available_resource_in(weapons)
    var passive_items_available = get_available_resource_in(passive_items)
    if weapons_available.size() == 0 and passive_items_available.size() == 0:
        return
    
    for slot in get_children():
        slot.queue_free()
    
    var option_size = 0
    for weapon in weapons_available:
        option_size += add_option(weapon)
        
        if weapon.max_level_reached() and weapon.item_needed in passive_items_available:
            var option_slot = OptionSlot.instantiate()
            option_slot.item = weapon
            add_child(option_slot)
            option_size += 1

    for passive_item in passive_items_available:
        option_size += add_option(passive_item)
    
    if option_size == 0:
        return
    
    show()
    particles.show()
    panel.show()
    get_tree().paused = true

func get_available_upgrades() -> Array[Item]:
    var upgrades: Array[Item] = []
    for weapon: Weapon in get_available_resource_in(weapons):
        if weapon.is_upgradable():
            upgrades.append(weapon)

    for passive_item: PassiveItem in get_available_resource_in(passive_items):
        if passive_item.is_upgradable():
            upgrades.append(passive_item)

    return upgrades
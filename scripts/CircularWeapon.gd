extends Weapon
class_name Circular

@export var angular_speed: float = 20
@export var radius: float = 20
@export var amount: int = 1

var projectile_reference: Array[Area2D]
var rotation_angle: float

func activate(source, _target, _scene_tree):
    reset()

    for i in range(amount):
        add_to_player(source)

func add_to_player(source):
    var projectile = projectile_node.instantiate()

    projectile.speed = 0
    projectile.damage = damage
    projectile.source = source
    #TODO: Make this reference better
    projectile.find_child("Sprite2D").texture = texture
    projectile.hide()

    projectile_reference.append(projectile)
    source.call_deferred("add_child",projectile)

func update(delta):
    rotation_angle += angular_speed * delta

    for i in range(projectile_reference.size()):
        var offset = i * (360.0/amount)

        projectile_reference[i].position = radius * Vector2(cos(deg_to_rad(rotation_angle + offset)), sin(deg_to_rad(rotation_angle + offset)))

        projectile_reference[i].show()

func reset():
    for i in range(projectile_reference.size()):
        projectile_reference.pop_front().queue_free()

func upgrade_item():
    if max_level_reached():
        #reset()
        slot_reference.item = evolution
        return
    
    if not is_upgradable():
        return
    
    var upgrade = upgrades[level - 1]

    angular_speed += upgrade.angular_speed
    amount += upgrade.amount
    damage += upgrade.damage

    level += 1
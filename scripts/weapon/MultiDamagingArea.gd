extends Weapon
class_name MultiDamagingArea

@export var amount: int = 1
@export var area: float = 1.5

@export var delay: float = 0.2
var counter: float = 0

var projectile_reference = []

func activate(source, _target, scene_tree):
    reset()
    SoundManager.play_sfx(sound)
    for i in range(amount):
        add_to_world(source, scene_tree)

    for i in range(projectile_reference.size()):
        var offset = i * (360.0/amount)
        projectile_reference[i].position = source.position + 100 * Vector2(cos(deg_to_rad(offset)), sin(deg_to_rad(offset)))
        projectile_reference[i].show()


func add_to_world(source, tree):
    var projectile = projectile_node.instantiate()
    projectile.speed = 0
    projectile.damage = damage
    projectile.source = source
    projectile.scale = Vector2(area, area)
    projectile.z_index = 0

    projectile.find_child("Sprite2D").texture = texture
    projectile.find_child("CollisionShape2D").shape.radius = 12
    projectile.hide()
    projectile.knockback = -40
    projectile_reference.append(projectile)

    tree.current_scene.call_deferred("add_child",projectile)

func reset():
    for i in range(projectile_reference.size()):
        var temp = projectile_reference.pop_front()
        if is_instance_valid(temp):
            temp.queue_free()

func reset_collision(value):
    for projectile in projectile_reference:
        if is_instance_valid(projectile):
            projectile.find_child("CollisionShape2D").disabled = value

func update(delta):
    counter += delta

    if counter > 2 * delay and projectile_reference.size() > 0:
        reset_collision(false)
        counter = 0
    elif counter > delay and projectile_reference.size() > 0:
        reset_collision(true)

func upgrade_item():
    if max_level_reached():
        slot_reference.item = evolution
        return
    
    if not is_upgradable():
        return

    var upgrade = upgrades[level - 1]

    area += upgrade.area
    damage += upgrade.damage
    amount += upgrade.amount

    level += 1
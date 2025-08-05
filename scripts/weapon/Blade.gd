extends Weapon
class_name Blade

@export var area: float = 1.0
@export var amount: int = 1
@export var reversible: bool = false
@export var delay: float = 0.3

var projectile_reference = null

func activate(source, _target, scene_tree):
    set_projectile(source, scene_tree)

func add_to_player(source, index):
    var projectile = projectile_node.instantiate()
    projectile.speed = speed
    projectile.damage = damage
    projectile.source = source
    projectile.scale = Vector2(area,area)

    projectile.find_child("CollisionShape2D").shape.radius = 12
    projectile.direction = (source.get_global_mouse_position() - source.position).normalized()

    if index % 2 == 1 and reversible:
        projectile.direction *= -1
    projectile.find_child("Sprite2D").texture = texture

    if projectile_reference != null:
        projectile_reference.queue_free()
    projectile_reference = projectile

    source.call_deferred("add_child",projectile)

func set_projectile(source, scene_tree: SceneTree):
    for i in range(amount):
        SoundManager.play_sfx(sound)
        add_to_player(source, i)
        await scene_tree.create_timer(delay).timeout
        if is_instance_valid(projectile_reference):
            projectile_reference.queue_free()

func upgrade_item():
    if max_level_reached():
        slot_reference.item = evolution
        return
    
    if not is_upgradable():
        return
    
    var upgrade = upgrades[level - 1]

    damage += upgrade.damage
    area += upgrade.area
    speed += upgrade.speed
    amount += upgrade.amount

    level += 1
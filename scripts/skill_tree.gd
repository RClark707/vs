extends Panel

var skill_tree: Array
var total_stats: Stats

func _ready():
    load_skill_tree()

func set_skill_tree():
    skill_tree = []
    for each_branch in get_children():
        var branch = []
        for upgrade in each_branch.get_children():
            branch.append(upgrade.enabled)
        skill_tree.append(branch)
    
    SaveData.skill_tree = skill_tree
    SaveData.set_and_save()

func load_skill_tree():
    if SaveData.skill_tree == []:
        set_skill_tree()
    
    skill_tree = SaveData.skill_tree
    for branch in get_children():
        for upgrade in branch.get_children():
            upgrade.enabled = skill_tree[branch.get_index()][upgrade.get_index()]
    get_total_stats()

func add_stats(stat):
    total_stats.max_health += stat.max_health
    total_stats.recovery += stat.recovery
    total_stats.armor += stat.armor
    total_stats.movement_speed += stat.movement_speed
    total_stats.might += stat.might
    total_stats.area += stat.area
    total_stats.growth += stat.growth

# TODO: Rename to apply_total_stats
func get_total_stats():
    total_stats = Stats.new()
    for branch in get_children():
        for upgrade in branch.get_children():
            if upgrade.enabled:
                add_stats(upgrade.skill.stats)
    Persistence.bonus_stats = total_stats
extends Node
class_name EnemyDropComponent


@export var drop_item: PackedScene
@export_range(0, 1) var drop_chance_base := 0.5
@export var health_component: HealthComponent


var drop_chance:
    get:
        return drop_chance_base


#region Lifecycle
func _ready() -> void:
    health_component.died.connect(on_died)
#endregion


#region Methods
#endregion


#region Listeners
func on_died():
    if !owner is Node2D or !drop_item:
        return

    if randf() > drop_chance:
        return
    
    var spawn_position = (owner as Node2D).global_position
    var drop_item_instance = drop_item.instantiate() as Node2D
    drop_item_instance.global_position = spawn_position
    ItemSpawnManager.instance.entities_node.add_child(drop_item_instance)

    if drop_item_instance is PickupItem:
        drop_item_instance.set_amount(1)
#endregion

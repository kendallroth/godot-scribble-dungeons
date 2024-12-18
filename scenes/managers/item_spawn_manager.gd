@tool
extends Node
class_name ItemSpawnManager


# NOTE: Uses separate reference to allow accessing initially prior to existing
static var _instance: ItemSpawnManager
static var instance: ItemSpawnManager:
    get:
        if !_instance:
            push_error("Item spawn manager did not exist!")
        return _instance


@export_group("References")
## Node for entities to be spawned under
@export var entities_node: Node:
    set(value):
        entities_node = value
        if Engine.is_editor_hint():
            update_configuration_warnings()
## Node for pickups to be spawned under
@export var pickups_node: Node:
    set(value):
        pickups_node = value
        if Engine.is_editor_hint():
            update_configuration_warnings()


#region Lifecycle
func _init() -> void:
    if _instance:
        push_error("'ItemSpawnManager' instance already instantiated!")
        return

    _instance = self


func _get_configuration_warnings() -> PackedStringArray:
    var warnings: Array[String] = []
    if !entities_node:
        warnings.append("Entities node missing!")
    if !pickups_node:
        warnings.append("Pickups node missing!")
    return warnings
#endregion

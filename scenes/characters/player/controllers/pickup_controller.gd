@tool
extends Node
class_name PickupManager

@export_group("References")
@export var pickup_area: Area2D:
    set(value):
        pickup_area = value
        if Engine.is_editor_hint():
            update_configuration_warnings()


#region Lifecycle
func _ready() -> void:
    pickup_area.area_entered.connect(on_area_entered)


func _get_configuration_warnings() -> PackedStringArray:
    var warnings: Array[String] = []
    if !pickup_area:
        warnings.append("Pickup area missing!")
    return warnings
#endregion


#region Listeners
func on_area_entered(other_area: Area2D):
    if !other_area.owner is PickupItem:
        return

    var pickup_item = other_area.owner as PickupItem
    pickup_item.collect(self.owner)
#endregion

extends Node
class_name WeaponManager

@export var current_weapon: Weapon = null

@export_group("References")
@export var weapon_mount: Node2D = null

var can_attack : bool:
    get:
        if !current_weapon:
            return false

        return current_weapon.can_attack


#region Lifecycle
func _process(_delta: float) -> void:
    var did_attack = Input.is_action_just_pressed("attack")
    if did_attack:
        trigger_attack()
#endregion


#region Methods
func trigger_attack():
    if !current_weapon or !can_attack:
        return

    current_weapon.attack()
#endregion

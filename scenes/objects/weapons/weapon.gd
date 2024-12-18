extends Node
class_name Weapon

@export_range(0, 100) var damage := 10
## Cooldown until weapon can be used again
@export_range(0, 10) var cooldown := 0.4

@export_group("References")
@export var weapon_sprite: Sprite2D
@export var hitbox_component: HitboxComponent

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var cooling_down := false

var can_attack : bool:
    get:
        return !cooling_down


#region Lifecycle
func _ready() -> void:
    hitbox_component.damage = damage
    trigger_cooldown()
#endregion


#region Methods
func attack():
    if !can_attack:
        return

    animation_player.play("attack")
    trigger_cooldown()


func trigger_cooldown():
    cooling_down = true
    display_cooldown()

    await get_tree().create_timer(cooldown).timeout

    cooling_down = false
    display_cooldown()


func display_cooldown():
    if !weapon_sprite:
        return
    
    weapon_sprite.modulate = Color.LIGHT_GRAY if cooling_down else Color.WHITE
#endregion
@tool
extends Node2D
class_name PickupItem


@export_range(0, 100) var pickup_amount := 1

# TODO: Investigate automatically detecting these like Unity `GetComponentInChildren` (perhaps with utility and warning system)?
@export_group("References")
@export var collision_shape: CollisionShape2D:
    set(value):
        collision_shape = value
        if Engine.is_editor_hint():
            update_configuration_warnings()
# @export var audio_player: AudioStreamPlayer2D:
#     set(value):
#         audio_player = value
#         if Engine.is_editor_hint():
#             update_configuration_warnings()
@export var pickup_sprite: Sprite2D


#region Lifecycle
func _get_configuration_warnings() -> PackedStringArray:
    var warnings: Array[String] = []
    if !collision_shape:
        warnings.append("Collision shape missing!")
    # if !audio_player:
    #     warnings.append("Audio player missing!")
    return warnings
#endregion


#region Methods
## Collect pickup item
func set_amount(value: int):
    pickup_amount = value


func tween_collect(percent: float, start_position: Vector2, target_node: Node2D):
    if !target_node:
        return

    global_position = start_position.lerp(target_node.position, percent)
    var direction_from_start := target_node.position - start_position
    var target_rotation := direction_from_start.angle() + deg_to_rad(90)
    rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))


func tween_collect_end():
    # NOTE: Must play sound before emitting event to avoid cutting off on levelup (audio player is set to non-pausable)
    # audio_player.play_random()
    GameEvents.player_collected_pickup.emit(self)
    # Must wait to remove pickup scene until pickup audio has finished (to avoid cutoff)
    # audio_player.finished.connect(queue_free)
    queue_free()


func collect(player: Node2D):
    if !player is Player:
        return

    # Disable collider to prevent subsequent/additional collisions
    # NOTE: Cannot disable collider inside a physics event (often called from physics)!
    Callable(func (): collision_shape.disabled = true).call_deferred()

    # TODO: Handle the tween if/once player dies (could "pop" out of existence?)!

    var tween := create_tween()
    tween.set_parallel()
    tween.tween_method(tween_collect.bind(global_position, player), 0.0, 1.0, 0.5)\
        .set_ease(Tween.EASE_IN)\
        .set_trans(Tween.TRANS_BACK)
    if pickup_sprite:
        tween.tween_property(pickup_sprite, "scale", Vector2.ZERO, 0.05)\
            .set_delay(0.45)
    tween.chain()
    tween.tween_callback(tween_collect_end)
#endregion

extends CharacterBody2D

## How far the enemy will target approaching the player
@export_range(0, 100) var player_offset := 50

@export_group("References")
@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent

var player_node: Node2D


#region Lifecycle
func _physics_process(_delta):
    if !player_node or !velocity_component:
        return

    # TODO: Figure out how to avoid the enemy moving too close to the player, while still supporting
    #         moving away from player. Without this check for target distance there is constant jittering...
    var target_position = get_target_position()
    if target_position.distance_to(global_position) < 2:
        return

    var direction = get_direction_to_player()
    velocity_component.accelerate_in_direction(direction)
    velocity_component.move(self)


func _process(_delta):
    player_node = get_player_node()
    if player_node:
        look_at(player_node.global_position)
#endregion


#region Methods
func get_player_node():
    if !player_node:
        player_node = get_tree().get_first_node_in_group("player")
    
    return player_node


func get_target_position() -> Vector2:
    player_node = get_player_node()
    if !player_node:
        return Vector2.ZERO
    
    var target_position = player_node.global_position
    # Move the enemy towards the player but never directly to it!
    return target_position + (global_position - target_position).normalized() * player_offset



func get_direction_to_player():
    var target_position = get_target_position()
    return (target_position - global_position).normalized()
#endregion


#region Listeners
#endregion

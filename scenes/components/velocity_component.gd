extends Node
class_name VelocityComponent


@export_range(1, 500) var max_speed := 250
## Acceleration controls the rate at which entities can change move direction (lower is slower)
@export_range(0, 100) var acceleration := 25

var velocity = Vector2.ZERO


#region Methods
func accelerate_in_direction(direction: Vector2):
    var desired_velocity = direction * max_speed
    velocity = velocity.lerp(desired_velocity, 1 - exp(-get_physics_process_delta_time() * acceleration))


func decelerate():
    accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
    character_body.velocity = velocity
    character_body.move_and_slide()
    velocity = character_body.velocity
#endregion

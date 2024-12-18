extends CharacterBody2D
class_name Player

enum PlayerMovementType {
    ## Move in direction of arrow keys
    TO_KEYS,
    ## Move towards camera
    TO_MOUSE
}

@export var movement_type := PlayerMovementType.TO_KEYS

@onready var remote_transform := $%CameraRemoteTransform
@onready var velocity_component := $Components/VelocityComponent


#region Lifecycle
func _ready():
    remote_transform.remote_path = get_viewport().get_camera_2d().get_path()


func _physics_process(_delta):
    var look_position = get_global_mouse_position()
    look_at(look_position)
    
    var direction = get_movement_direction()
    if (movement_type == PlayerMovementType.TO_MOUSE):
        # Prevent rapidly flipping back and forth when mouse is immediately over player
        # TODO: Fix the still-possible slow movement at border of this radius...
        if (position.distance_to(look_position) <= 25):
            direction = Vector2.ZERO
        direction = direction.rotated(rotation).rotated(deg_to_rad(90))
    
    velocity_component.accelerate_in_direction(direction)
    velocity_component.move(self)
#endregion


#region Methods
func get_movement_direction() -> Vector2:
    var movement_x = Input.get_axis("move_left", "move_right")
    var movement_y = Input.get_axis("move_up", "move_down")

    # Remove/ignore strafing input when moving towards mouse
    if (movement_type == PlayerMovementType.TO_MOUSE):
        movement_x = 0

    var movement = Vector2(movement_x, movement_y)
    return movement.normalized()
#endregion


#region Listeners
#endregion

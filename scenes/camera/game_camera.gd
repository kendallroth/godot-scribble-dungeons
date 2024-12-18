extends Camera2D

var player_node: Node2D
var target_position = Vector2.ZERO


#region Lifecycle
func _ready():
    # Set camera as current game camera
    make_current()
    
    # Snap camera to target upon load
    acquire_target()
    global_position = target_position


func _process(delta):
    acquire_target()
    # Frame-rate independent lerp
    # https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
    const lerp_rate = 10
    global_position = global_position.lerp(target_position, 1 - exp(-delta * lerp_rate))
#endregion


#region Methods
func acquire_target():
    if not player_node:
        player_node = get_tree().get_first_node_in_group("player")

    target_position = player_node.global_position
#endregion

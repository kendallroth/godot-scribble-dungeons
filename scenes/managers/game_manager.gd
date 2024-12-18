extends Node
class_name GameManager


signal game_time_changed(seconds: int)


@onready var seconds_timer = $%SecondsTimer

## Elapsed game time (in seconds)
var game_time_elapsed := 0


#region Lifecycle
func _ready() -> void:
    seconds_timer.start()
    seconds_timer.timeout.connect(on_timer_tick)

    # NOTE: Must wait to emit event until next frame (to allow listeners to attach)
    Callable(func(): game_time_changed.emit(game_time_elapsed)).call_deferred()
#endregion


#region Methods
#endregion


#region Listeners
func on_timer_tick():
    game_time_elapsed += 1
    game_time_changed.emit(game_time_elapsed)
#endregion
# AUTOLOADED

extends Node

# TODO: Consider strongly typing signals via wrapping functions 🤷‍♂️

# Player event signals
signal player_died()
signal player_experience_changed(
    current_level_experience: int, current_level_progress: float, change: int, total_experience: int
)
signal player_health_changed(current_health: float, change: float, max_health: float)
signal player_level_changed(level: int)
signal player_collected_pickup(pickup: PickupItem)

# Enemy event signals
signal enemy_killed(position: Vector2)
signal enemy_spawned(position: Vector2)

@tool
extends CanvasLayer


@onready var time_label = $%TimeLabel
@onready var experience_bar = $%ExperienceProgress
@onready var experience_label = $%ExperienceLabel
@onready var level_label = $%LevelLabel

# TODO: Consider listening via game events instead (being sent anyway...)
# TODO: Investigate automatically detecting these like Unity `GetComponentInChildren` (perhaps with utility and warning system)?
@export_group("References")
@export var experience_manager: ExperienceManager:
    set(value):
        experience_manager = value
        if Engine.is_editor_hint():
            update_configuration_warnings()
@export var game_manager: GameManager:
    set(value):
        game_manager = value
        if Engine.is_editor_hint():
            update_configuration_warnings()


#region Lifecycle
func _ready() -> void:
    experience_manager.experience_updated.connect(on_experience_updated)
    experience_manager.leveled_up.connect(on_leveled_up)
    game_manager.game_time_changed.connect(on_game_time_updated)

    experience_label.text = format_experience_label(
        experience_manager.current_experience,
        experience_manager.target_experience
    )
    experience_bar.value = experience_manager.current_experience


func _get_configuration_warnings() -> PackedStringArray:
    var warnings: Array[String] = []
    if !game_manager:
        warnings.append("Game manager missing!")
    if !experience_manager:
        warnings.append("Experience manager missing!")
    return warnings
#endregion


#region Methods
func format_experience_label(current: int, target: int):
    return "%s / %s" % [current, target]
#endregion


#region Listeners
func on_experience_updated(current_experience: int, target_experience: int):
    experience_bar.value = current_experience / float(target_experience)
    experience_label.text = format_experience_label(current_experience, target_experience)


func on_leveled_up(level: int):
    level_label.text = str(level)


func on_game_time_updated(seconds: int):
    @warning_ignore("integer_division")
    var minutes = seconds / 60
    var remaining_seconds = floori(seconds - (minutes * 60))
    var time_string = "%s:%02d" % [minutes, remaining_seconds]
    time_label.text = time_string
#endregion

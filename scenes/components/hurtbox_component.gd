extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent


#region Lifecycle
func _ready():
    area_entered.connect(on_area_entered)
#endregion


#region Methods
#endregion


#region Listeners
func on_area_entered(other_area: Area2D):
    if !other_area is HitboxComponent:
        return
    if !health_component:
        push_warning("No health component for ", owner.name)
        return
    
    var hitbox_component := other_area as HitboxComponent
    health_component.damage(hitbox_component.damage)
#endregion
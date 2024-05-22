extends AttackAreaComponent

@export var movement_component: MovementComponent

func _is_active() -> bool:
	return movement_component.character.velocity.y >= 0

# this method is called inside the hitbox taking the attack
# this ensures that is_active() will return true
func on_area_entered(area):
	if is_active() and area is HitboxComponent and area.health_component.can_take_damage:
		var normal: Vector2 = area.gravity_center.global_position.direction_to(gravity_center.global_position)
		movement_component.knock(normal, false)

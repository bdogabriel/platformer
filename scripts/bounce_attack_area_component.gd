extends AttackAreaComponent

@export var movement_component: MovementComponent

func _is_active() -> bool:
	return not movement_component.character.is_on_floor() and movement_component.character.velocity.y >= 0

# this method is called inside the hitbox taking the attack
# this ensures that is_active() will return true
func on_attack_hit(normal: Vector2):
		movement_component.knock(-1 * normal, false)

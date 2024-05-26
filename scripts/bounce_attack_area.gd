extends AttackArea

@export var movement_component: MovementComponent

func _is_active() -> bool:
	return not movement_component.character.is_on_floor() and movement_component.character.velocity.y >= 0

func _on_attack_hit(normal: Vector2) -> void:
		movement_component.knock(normal, false)

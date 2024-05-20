class_name AttackAreaComponent extends Area2D

@export var attack_component: AttackComponent

# to override
func _is_active() -> bool:
	return true

func is_active() -> bool:
	return attack_component.can_attack and _is_active()

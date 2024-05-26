class_name AttackArea extends Area2D

@export var gravity_center: Marker2D

var attack_component: AttackComponent # set by AttackComponent

# to override
func _is_active() -> bool:
	return true

func is_active() -> bool:
	return attack_component.can_attack and _is_active()

func _on_attack_hit(_normal: Vector2) -> void:
	pass

# this method is called inside the hitbox taking the attack
# this ensures that is_active() will return true
# parameter is normal vector of collision, calculated with the gravity centers
func on_attack_hit(normal: Vector2) -> void:
	if not is_active():
		return
	_on_attack_hit(normal)

func deal_damage() -> float:
	return attack_component.deal_damage()

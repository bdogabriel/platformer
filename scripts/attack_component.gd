class_name AttackComponent extends Node

@export var damage: float = 1

@onready var stop_attacking_timer: Timer = $StopAttackingTimer

var can_attack: bool = true

func _process(_delta):
	if not stop_attacking_timer.time_left:
		can_attack = true

func deal_damage() -> float:
	return damage if can_attack else 0.0

func stop_attacking(time: float = 0.4):
	can_attack = false
	stop_attacking_timer.start(time)

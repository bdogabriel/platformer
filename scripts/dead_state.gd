extends State

@export var health_component: HealthComponent
@export var attack_component: AttackComponent
@export var movement_component: MovementComponent

@onready var character: CharacterBody2D = movement_component.character

func _enter(_last_state_name):
	state_machine.freeze()
	movement_component.stop_movement(5)
	health_component.stop_taking_damage(5)
	attack_component.stop_attacking(5)
	await get_tree().create_timer(3.0).timeout
	character.queue_free()

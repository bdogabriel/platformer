class_name BaseCharacter extends CharacterBody2D

@export var animation_handler_component: AnimationHandlerComponent
@export var attack_component: AttackComponent
@export var health_component: HealthComponent
@export var movement_component: MovementComponent
@export var state_machine: StateMachine

func _ready():
	if not health_component.is_connected("hit", _on_hit):
		health_component.hit.connect(_on_hit)
	movement_component.character = self
	animation_handler_component.character = self
	animation_handler_component.movement_component = movement_component
	for hitbox in health_component.hitboxes:
		hitbox.movement_component = movement_component
	animation_handler_component.set_state("hit_taken", "not_dead")

func _on_hit():
	animation_handler_component.fire_one_shot("hit_one_shot")
	if health_component.hp <= 0:
		animation_handler_component.set_state("movement", "dead")
		animation_handler_component.set_state("hit_taken", "dead")
		_die()

func _die():
	movement_component.stop_movement(5)
	health_component.stop_taking_damage(5)
	attack_component.stop_attacking(5)
	animation_handler_component.set_physics_process(false)
	await get_tree().create_timer(3.0).timeout
	queue_free()

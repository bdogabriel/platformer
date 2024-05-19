extends Area2D

@export var movement_component: MovementComponent

@onready var collision_shape: CollisionShape2D = get_child(0)

func _on_area_entered(_area):
	if movement_component.character.velocity.y > 0:
		movement_component.jump()

class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent

func _process(_delta: float) -> void:
	GameManager.player_global_position = position

func _physics_process(_delta):
	movement_component.set_direction(Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")))

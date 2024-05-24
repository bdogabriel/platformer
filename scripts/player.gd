class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var health_component: HealthComponent

func _ready():
	GameManager.player_health_component = health_component

func _process(_delta: float) -> void:
	GameManager.player_global_position = position

func _physics_process(_delta):
	var direction: Vector2i = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	movement_component.set_direction(direction)

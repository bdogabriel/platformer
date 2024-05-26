class_name Pickup extends Node2D

@onready var area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Player) -> void:
	animated_sprite.play("picked_up")
	await animated_sprite.animation_finished
	_on_picked_up(body)
	queue_free()

func _on_picked_up(_player: Player) -> void:
	pass

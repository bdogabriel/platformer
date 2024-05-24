class_name Pickup extends Node2D

@onready var area: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _process(_delta) -> void:
	if not animated_sprite.is_playing():
		queue_free()

func _on_body_entered(body: Player) -> void:
	animated_sprite.play("picked_up")
	_on_picked_up(body)
	set_process(true)
	area.queue_free()

func _on_picked_up(_player: Player) -> void:
	pass

extends Path2D

@export var closed: bool = false
@export var speed_scale: float = 1.0

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	animation.speed_scale = speed_scale
	if closed:
		animation.play("move_closed")
	else:
		animation.play("move_open")

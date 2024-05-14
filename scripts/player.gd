class_name Player extends BaseCharacter

func _process(delta: float) -> void:
	super(delta)
	GameManager.player_global_position = position

func set_direction() -> void:
	direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))

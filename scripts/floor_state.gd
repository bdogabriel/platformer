extends MovementState

func _process(_delta):
	if not character.is_on_floor():
		movement_state_machine.change_state(name_format(), "air")

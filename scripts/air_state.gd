extends MovementState

func _process(_delta):
	if character.is_on_floor():
		if not movement_component.direction.x:
			movement_state_machine.change_state(name_format(), "landing")
		else:
			movement_state_machine.change_state(name_format(), "floor")

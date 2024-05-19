extends MovementState

func _process(_delta):
	if character.is_on_floor():
		if not movement_component.direction.x:
			change_state.emit(self, "landing")
		else:
			change_state.emit(self, "floor")

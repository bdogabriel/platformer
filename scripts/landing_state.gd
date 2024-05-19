extends MovementState

func _process(_delta):
	if character.is_on_floor():
		if movement_component.direction.x:
			change_state.emit(self, "floor")
	else:
		change_state.emit(self, "air")

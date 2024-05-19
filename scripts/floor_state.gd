extends MovementState

func _process(_delta):
	if not character.is_on_floor():
		change_state.emit(self, "air")

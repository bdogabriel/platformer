extends MovementState

var _processed_landing: bool

func _enter(_last_state_name):
	_processed_landing = false

func _process(_delta):
	if _processed_landing:
		if character.is_on_floor():
			movement_state_machine.change_state(name_format(), "floor")
		else:
			movement_state_machine.change_state(name_format(), "air")
	else:
		_processed_landing = true
	
	

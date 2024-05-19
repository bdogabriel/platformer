class_name StateMachine extends State

@export var initial_states: Array[String]

var states_dict: Dictionary
var current_states: Dictionary

func _ready():
	_update_states_dict()
	for state in initial_states:
		_current_states_add(state)

func _on_change_state(state: State, next_state_name: String) -> void:
	var state_name = state.name_format()
	if state_name != next_state_name and current_states.has(state_name):
		_current_states_remove(state.name_format())
		_current_states_add(next_state_name)

func _current_states_add(state_name: String) -> void:
	var state: State = get_state(state_name)
	current_states[state_name] = state
	state.enter()

func _current_states_remove(state_name: String) -> void:
	var state : State = current_states.get(state_name)
	current_states.erase(state_name)
	state.exit()

func _update_states_dict() -> void:
	states_dict.clear()
	var states_list: Array[State] = []
	states_list.assign(find_children("*", "State", false))
	for state in states_list:
		state.change_state.connect(_on_change_state)
		states_dict[state.name_format()] = state

# getters
func get_state(state_name: String) -> State:
	return states_dict.get(state_name)

func get_current_states(recursive: bool = false) -> Array[State]:
	var ret: Array[State] = []
	ret.assign(current_states.values())
	if recursive:
		for state in ret:
			if state is StateMachine:
				ret.append_array(state.get_current_states())
	return ret

func get_current_states_names(recursive: bool = false) -> Array[String]:
	var ret: Array[String] = []
	var temp: Array[State] = []
	temp.assign(get_current_states(recursive))
	for state in temp:
		ret.append(state.name_format())
	return ret

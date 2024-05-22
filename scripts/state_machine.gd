class_name StateMachine extends State

@export var initial_states: Array[State]

var states_dict: Dictionary
var current_states: Dictionary

var frozen = false

func _ready():
	_update_states_dict()
	for state in initial_states:
		_current_states_add(state.name_format())

func change_state(state_name: String, next_state_name: String) -> void:
	if frozen:
		return
	if state_name != next_state_name and current_states.has(state_name):
		_current_states_remove(state_name)
		_current_states_add(next_state_name, state_name)

func _current_states_add(state_name: String, last_state_name: String = "") -> void:
	var state: State = get_state(state_name)
	current_states[state_name] = state
	state.enter(last_state_name)

func _current_states_remove(state_name: String) -> void:
	var state : State = current_states.get(state_name)
	current_states.erase(state_name)
	state.exit()

func _update_states_dict() -> void:
	states_dict.clear()
	var states_list: Array[State] = []
	states_list.assign(find_children("*", "State", false))
	for state in states_list:
		states_dict[state.name_format()] = state

# helper to filter array
func _check_filters(state: State, filters: Dictionary = {}):
	for filter_name in filters.keys():
		if not (state[filter_name] == filters[filter_name]):
			return false
	return true

# can't change states
func freeze(recursive: bool = true) -> void:
	frozen = true
	if not recursive:
		return
	for state in states_dict.values():
		if state is StateMachine:
			state.freeze()

func unfreeze(recursive: bool = true) -> void:
	frozen = false
	if not recursive:
		return
	for state in states_dict.values():
		if state is StateMachine:
			state.unfreeze()

# getters
func get_state(state_name: String) -> State:
	return states_dict.get(state_name)

func get_current_states(recursive: bool = false, filters: Dictionary = {}) -> Array[State]:
	var ret: Array[State] = []
	ret.assign(current_states.values())
	ret = ret.filter(func (state: State) -> bool: return _check_filters(state, filters))
	if recursive:
		for state in ret:
			if state is StateMachine:
				ret.append_array(state.get_current_states(recursive, filters))
	return ret

func get_current_states_names(recursive: bool = false, filters: Dictionary = {}) -> Array[String]:
	var ret: Array[String] = []
	var temp: Array[State] = []
	temp.assign(get_current_states(recursive, filters))
	for state in temp:
		ret.append(state.name_format())
	return ret

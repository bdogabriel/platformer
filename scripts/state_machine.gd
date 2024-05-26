class_name StateMachine extends Node2D

@export var initial_state: State

var states_dict: Dictionary
var current_state: State

var frozen = false

func _ready():
	_update_states_dict()
	current_state = initial_state
	current_state.enter()

func change_state(next_state_name: String) -> void:
	if frozen:
		return
	if next_state_name != current_state.name_format():
		current_state.exit()
		current_state = get_state(next_state_name)
		current_state.enter()

func _update_states_dict() -> void:
	if frozen:
		return
	states_dict.clear()
	var states_list: Array[State] = []
	states_list.assign(find_children("*", "State", false))
	for state in states_list:
		states_dict[state.name_format()] = state

func get_state(state_name: String) -> State:
	return states_dict.get(state_name)

class_name StateMachine extends Node

@export var character: CharacterBody2D
@export var movement_component: MovementComponent
@export var initial_states: Array[String]

var states_dict: Dictionary
var current_states: Dictionary

func _ready():
	update_states_dict()
	for state in initial_states:
		current_states_add(state)

func current_states_add(state_name: String) -> void:
	var state: State = get_state(state_name)
	current_states[state_name] = state
	state.enter()

func current_states_remove(state_name: String) -> void:
	var state : State = current_states.get(state_name)
	current_states.erase(state_name)
	state.exit()

func states_dict_add(state: State) -> void:
	states_dict[state.name_format()] = state

func states_dict_remove(state_name: String) -> void:
	states_dict.erase(state_name)

func update_states_dict() -> void:
	states_dict.clear()
	var state_list: Array[Node] = get_children()
	for state in state_list:
		if state is State:
			state.change_state.connect(on_change_state)
			states_dict_add(state)

func on_change_state(state: State, next_state_name: String) -> void:
	var state_name = state.name_format()
	if state_name != next_state_name and current_states.has(state_name):
		current_states_remove(state.name_format())
		current_states_add(next_state_name)

# getters
func get_state(state_name: String) -> State:
	return states_dict.get(state_name)

func get_current_states_names() -> Array:
	return current_states.keys()

func get_current_animated_states_names() -> Array[String]:
	var ret: Array[String] = []
	for state: State in current_states.values():
		if state.has_animation:
			ret.append(state.name_format())
	return ret

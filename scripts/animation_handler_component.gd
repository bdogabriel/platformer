class_name AnimationHandlerComponent extends Node

@export var state_machine: StateMachine
@export var animation_tree: AnimationTree
@export var movement_component: MovementComponent
@export var facing_right: bool = true

@onready var character: CharacterBody2D = movement_component.character

var current_animated_state: String

func _ready():
	animation_tree.active = true

func _process(_delta):
	update_animation_tree()

func update_animation_tree():
	animation_tree.set("parameters/movement/air/blend_position", character.velocity.normalized().y)
	animation_tree.set("parameters/movement/floor/blend_position", movement_component.direction.x)
	check_flip()
	
	if not current_animated_state in state_machine.get_current_states_names(true):
		_travel_to_next_state(state_machine, "parameters/")

func check_flip() -> void:
	if facing_right:
		if movement_component.direction.x < 0:
			flip()
	else:
		if movement_component.direction.x > 0:
			flip()

func flip() -> void:
	facing_right = not facing_right
	character.scale.x = abs(character.scale.x) * -1

func _travel_to_next_state(sm: StateMachine, playback_base_path: String) -> void:
	var playback: AnimationNodeStateMachinePlayback
	var pbp = playback_base_path
	for state in sm.get_current_states():
		if state.has_animation:
			if state is StateMachine:
				pbp += state.name_format() + "/"
				_travel_to_next_state(state, pbp)
			else:
				current_animated_state = state.name_format()
				playback = animation_tree[playback_base_path + "playback"]
				playback.travel(current_animated_state)

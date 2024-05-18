class_name AnimationHandlerComponent extends Node

@export var state_machine: StateMachine
@export var animation_tree: AnimationTree
@export var movement_component: MovementComponent
@export var facing_right: bool = true

var playback: AnimationNodeStateMachinePlayback
var character: CharacterBody2D
var last_states_names: Array[String]

func _ready():
	animation_tree.active = true
	playback = animation_tree["parameters/playback"]
	character = state_machine.character

func _process(_delta):
	update_animation_tree()

func update_animation_tree():
	animation_tree.set("parameters/air/blend_position", character.velocity.normalized().y)
	animation_tree.set("parameters/floor/blend_position", movement_component.direction.x)
	check_flip()
	
	var current_states_names = state_machine.get_current_animated_states_names()
	
	if current_states_names != last_states_names:
		last_states_names = current_states_names
		if current_states_names.size():
			playback.travel(current_states_names[0])

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

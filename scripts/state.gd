class_name State extends Node

@export var has_animation: bool = true

var state_machine: StateMachine
var character: CharacterBody2D
var movement_component: MovementComponent

signal change_state

func _ready() -> void:
	state_machine = get_parent()
	character = state_machine.character
	movement_component = state_machine.movement_component

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func name_format() -> String:
	return name.to_snake_case().replace("_state", "")

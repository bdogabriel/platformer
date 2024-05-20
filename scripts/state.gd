class_name State extends Node

@export var has_animation: bool = true

@onready var state_machine: StateMachine = find_parent("*StateMachine")

var prev_state_name: String

func _enter(_last_state_name: String) -> void:
	pass
	
func _exit() -> void:
	pass

func enter(last_state_name: String = "") -> void:
	prev_state_name = last_state_name
	_enter(last_state_name)
	
func exit() -> void:
	_exit()

func name_format() -> String:
	return name.to_snake_case().replace("_state", "").replace("_machine", "")

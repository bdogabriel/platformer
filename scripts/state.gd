class_name State extends Node

@export var has_animation: bool = true

@onready var state_machine: StateMachine = find_parent("*StateMachine")

signal change_state

func _enter() -> void:
	pass
	
func _exit() -> void:
	pass

func enter() -> void:
	_enter()
	
func exit() -> void:
	_exit()

func name_format() -> String:
	return name.to_snake_case().replace("_state", "").replace("_machine", "")

class_name State extends Node2D

@onready var state_machine: StateMachine = find_parent("*StateMachine")

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

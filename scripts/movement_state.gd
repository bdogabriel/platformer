class_name MovementState extends State

@onready var movement_state_machine: MovementStateMachine = find_parent("MovementStateMachine")
@onready var movement_component: MovementComponent = movement_state_machine.movement_component
@onready var character: CharacterBody2D = movement_component.character

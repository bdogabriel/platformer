class_name NavigationComponent extends Node2D

const JUMP_MIN_Y_DIRECTION: float = 0.8 # to avoid jumping too much (when is not necessary)
const RUN_MIN_X_DIRECTION: float = 0.1

@export var movement_component: MovementComponent

@onready var character = movement_component.character
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var navigation_agent_timer: Timer = $Timer

var update_target_func: Callable = func update_target(_navigation_agent: NavigationAgent2D) -> void:
	pass

# wait for the first physics frame so the NavigationServer can sync.
func navigation_server_sync() -> void:
	await get_tree().physics_frame
	set_physics_process(true)

func _ready() -> void:
	set_physics_process(false)
	call_deferred("navigation_server_sync")
	navigation_agent_timer.timeout.connect(_on_nav_agent_timer_timeout)
	navigation_agent.target_position = character.global_position

func _physics_process(_delta) -> void:
	var dir: Vector2 = character.global_position.direction_to(navigation_agent.get_next_path_position())
	
	# this avoids jumping when not necessary
	# like when it is already in the destination or far enough that jumping is useless
	if abs(dir.y) < JUMP_MIN_Y_DIRECTION or navigation_agent.is_navigation_finished():
		dir.y = 0
	
	# just want 0, 1 or -1
	movement_component.set_direction(dir.round())

# setters
func set_update_target_func(function: Callable) -> void:
	update_target_func = function
	if character:
		navigation_agent.target_position = character.global_position # reset target position

# signal callbacks
func _on_nav_agent_timer_timeout() -> void:
	update_target_func.call(navigation_agent)

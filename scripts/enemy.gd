class_name Enemy extends BaseCharacter

const JUMP_MIN_Y_DIRECTION: float = 0.9 # to avoid jumping too much (when is not necessary)

@export_category("PathFinding")
@export var patrol_points: Array[Marker2D]
@export var jump_height: float = 140

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var nav_agent_timer: Timer = $NavAgentTimer
var aggro: bool = false

func set_direction() -> void:
	var dir: Vector2 = global_position.direction_to(nav_agent.get_next_path_position())
	
	# this avoids jumping when not necessary
	# like when it is already in the destination or far enough that jumping is useless
	if abs(dir.y) < JUMP_MIN_Y_DIRECTION or nav_agent.is_target_reached():
		dir.y = 0

	direction = dir.round()

func get_next_patrol_point() -> Vector2:
	var index: int = randi_range(0, patrol_points.size() - 1)
	return patrol_points[index].global_position

func update_target() -> void:
	var target: Vector2 = nav_agent.target_position
	
	if aggro:
		target = GameManager.player_global_position
	else:
		if nav_agent.is_target_reached() or not target:
			target = get_next_patrol_point()
	
	nav_agent.target_position = target

func _on_nav_agent_timer_timeout() -> void:
	update_target()

func _on_aggro_range_body_entered(body: BaseCharacter) -> void:
	if body.is_in_group("player"):
		aggro = true

func _on_aggro_range_body_exited(body: BaseCharacter) -> void:
	if body.is_in_group("player"):
		aggro = false
		nav_agent.target_position = get_next_patrol_point()

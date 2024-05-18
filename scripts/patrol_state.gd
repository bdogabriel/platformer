extends State

@export var navigation_component: NavigationComponent
@export var patrol_points: Array[Marker2D]

func _ready() -> void:
	super()
	if not patrol_points:
		if character is Enemy and character.patrol_points:
			patrol_points = character.patrol_points
		else:
			var marker = Marker2D.new()
			marker.global_position = character.global_position
			patrol_points.append(marker)

func enter() -> void:
	navigation_component.set_update_target_func(update_target)

func update_target(navigation_agent: NavigationAgent2D) -> void:
	if navigation_agent.is_navigation_finished():
		navigation_agent.target_position = get_next_patrol_point()
	
func get_next_patrol_point() -> Vector2:
	var index: int = randi_range(0, patrol_points.size() - 1)
	return patrol_points[index].global_position

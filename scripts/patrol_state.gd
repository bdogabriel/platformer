extends State

@export var navigation_component: NavigationComponent

@onready var character: CharacterBody2D = navigation_component.movement_component.character

var patrol_points: Array[Marker2D]

func _ready() -> void:
	if not patrol_points:
		if character is Enemy and character.patrol_points:
			patrol_points = character.patrol_points
		else:
			var marker = Marker2D.new()
			marker.global_position = character.global_position
			patrol_points.append(marker)

func _enter() -> void:
	navigation_component.set_update_target_func(_update_target)

func _update_target(navigation_agent: NavigationAgent2D) -> void:
	if navigation_agent.is_navigation_finished():
		navigation_agent.target_position = _get_next_patrol_point()
	
func _get_next_patrol_point() -> Vector2:
	return patrol_points.pick_random().global_position

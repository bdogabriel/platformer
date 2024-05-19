extends State

@export var aggro_area: Area2D
@export var navigation_component: NavigationComponent
@export var lose_aggro_radius: float

@onready var aggro_circle: CircleShape2D = aggro_area.get_child(0).shape
@onready var original_aggro_radius: float = aggro_circle.radius

func _ready():
	aggro_area.body_entered.connect(_on_aggro_area_body_entered)
	aggro_area.body_exited.connect(_on_aggro_area_body_exited)

func _enter():
	navigation_component.set_update_target_func(_update_target)

func _update_target(navigation_agent: NavigationAgent2D) -> void:
	navigation_agent.target_position = GameManager.player_global_position

func _on_aggro_area_body_entered(body) -> void:
	if body.is_in_group("player"):
		aggro_circle.radius = lose_aggro_radius
		change_state.emit(state_machine.get_state("patrol"), name_format())
		
func _on_aggro_area_body_exited(body) -> void:
	if body.is_in_group("player"):
		aggro_circle.radius = original_aggro_radius
		change_state.emit(self, "patrol")

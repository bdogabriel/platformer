extends State

@export var navigation_component: NavigationComponent
@export var aggro_radius: float = 400
@export var lose_aggro_radius: float = 600

@onready var aggro_area: Area2D = $Area2D
@onready var aggro_circle: CircleShape2D = CircleShape2D.new()

func _ready():
	aggro_area.body_entered.connect(_on_aggro_area_body_entered)
	aggro_area.body_exited.connect(_on_aggro_area_body_exited)
	
	aggro_circle.radius = aggro_radius
	var collision_shape = aggro_area.get_child(0)
	collision_shape.shape = aggro_circle

# in case player starts inside aggro area
func _physics_process(_delta):
	if GameManager.player in aggro_area.get_overlapping_bodies():
		aggro_circle.radius = lose_aggro_radius
		state_machine.change_state(name_format())
		set_physics_process(false)

func _enter():
	navigation_component.set_update_target_func(_update_target)

func _update_target(navigation_agent: NavigationAgent2D) -> void:
	navigation_agent.target_position = GameManager.player.global_position

func _on_aggro_area_body_entered(body) -> void:
	if body.is_in_group("player"):
		aggro_circle.radius = lose_aggro_radius
		state_machine.change_state(name_format())

func _on_aggro_area_body_exited(body) -> void:
	if body.is_in_group("player"):
		aggro_circle.radius = aggro_radius
		state_machine.change_state("patrol")

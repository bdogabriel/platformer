extends State

@export var movement_component: MovementComponent
@export var hitbox_components: Array[HitboxComponent]

var _processed_hit: bool

func _ready():
	for hitbox in hitbox_components:
		hitbox.hit.connect(_on_hit)

func _process(_delta):
	if _processed_hit:
		state_machine.change_state(name_format(), "movement")
	else:
		_processed_hit = true

func _on_hit(knock_dir: Vector2, current_hp: float):
	var current_animated_states_names: Array[String] = state_machine.get_current_states_names(false, {"has_animation": true})
	var next_state = name_format() if current_hp > 0 else "dead"
	if next_state == name_format():
		_processed_hit = false

	movement_component.knock(knock_dir)
	state_machine.change_state(current_animated_states_names[0], next_state)

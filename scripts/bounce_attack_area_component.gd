extends AttackAreaComponent

@export var movement_component: MovementComponent

func _ready():
	area_entered.connect(_on_area_entered)

func _is_active() -> bool:
	return movement_component.character.velocity.y > 0

func _on_area_entered(_area):
	if is_active():
		movement_component.jump()

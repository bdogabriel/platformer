class_name Hitbox extends Area2D

@export var gravity_center: Marker2D

var movement_component: MovementComponent # set by BaseCharacter
var health_component: HealthComponent # set by HealthComponent

func _ready():
	if not area_entered.is_connected(_on_attack_area_entered):
		area_entered.connect(_on_attack_area_entered)

# to override
func _is_active() -> bool:
	return true

func is_active() -> bool:
	return health_component.can_take_damage and _is_active()

func _on_attack_area_entered(area: AttackArea) -> void:
	if not is_active() or not area.is_active():
		return
	
	health_component.take_damage(area.deal_damage())
	
	var normal = gravity_center.global_position.direction_to(area.gravity_center.global_position)
	area.on_attack_hit(normal)
	movement_component.knock(-1 * normal)

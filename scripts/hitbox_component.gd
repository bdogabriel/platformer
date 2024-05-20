class_name HitboxComponent extends Area2D

@export var health_component: HealthComponent

signal hit

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if health_component.can_take_damage and area is AttackAreaComponent and area.is_active():
		var damage: float = area.attack_component.deal_damage()
		var current_hp: float = health_component.take_damage(damage)
		hit.emit(area.global_position.direction_to(global_position), current_hp)
		
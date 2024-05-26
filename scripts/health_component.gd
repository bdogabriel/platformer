class_name HealthComponent extends Node

@export var max_hp: float = 5
@export var hitboxes: Array[Hitbox]

@onready var hp: float = max_hp
@onready var stop_taking_damage_timer: Timer = $StopTakingDamageTimer

var can_take_damage: bool = true

signal hit

func _ready():
	set_process(false)
	for hitbox in hitboxes:
		hitbox.health_component = self

func process(_delta):
	if not stop_taking_damage_timer.time_left:
		can_take_damage = true

func take_damage(damage: float) -> float:
	if can_take_damage:
		hp = max(hp - damage, 0)
		hit.emit()
	return hp

func heal(amount: float) -> void:
	hp = min(hp + amount, max_hp)

func stop_taking_damage(time: float = 0.4):
	can_take_damage = false
	stop_taking_damage_timer.start(time)
	set_process(true)

class_name MovementComponent extends Node

@export var character: CharacterBody2D
@export var speed: float = 5
@export_range(0, 1) var acceleration: float = 0.3
@export var gravity: float = 50
@export var jump_initial_velocity: float = 12.5
@export var jump_acceleration: float = 1.75
@export var jump_acceleration_time: float = 1

# to work with smaller numbers on inspector
# times scale.x to keep physics consistent when changing character scale
@onready var delta_multiplier: float = 100 * character.scale.x
@onready var jump_acceleration_timer: Timer # time period in wich character is jumping (gaining acceleration)
@onready var stop_movement_timer: Timer = $StopMovementTimer

var jump_inertia: float # keep jump last direction if no x direction is set in set_direction
var direction: Vector2i # vector that tells character movement direction (or intended movement direction)
var last_direction: Vector2i
var can_move: bool = true

func _ready() -> void:
	gravity *= delta_multiplier
	speed *= delta_multiplier
	acceleration *= delta_multiplier
	jump_initial_velocity *= -1 * delta_multiplier
	jump_acceleration *= -1 * delta_multiplier * 10 # times 10 because gravity is hard to beat
	jump_acceleration_timer = $JumpTimer
	jump_acceleration_timer.wait_time = jump_acceleration_time

func _physics_process(delta: float) -> void:
	if not stop_movement_timer.time_left:
		can_move = true
	
	var target_velocity_x: float = direction.x * speed if can_move else 0.0
	var is_jumping: bool = direction.y < 0 and can_move
	
	if character.is_on_floor():
		jump_inertia = 0
		# go down on platforms
		if direction.y > 0:
			character.position.y += 5
		elif is_jumping:
			jump()

	# jumping
	else:
		character.velocity.y += gravity * delta
		# if jump and hold, goes further
		if jump_acceleration_timer.time_left:
			if is_jumping:
				character.velocity.y += jump_acceleration * delta
			else:
				jump_acceleration_timer.stop()

		# if changes directions mid-air
		if direction.x != last_direction.x:
			# if not going in any direction, keep last direction momentum
			if not direction.x:
				jump_inertia = last_direction.x * 0.5
		elif direction.x:
			jump_inertia = direction.x

		target_velocity_x = speed * jump_inertia

	# move_toward function to smoothen movement
	character.velocity.x = move_toward(character.velocity.x, target_velocity_x, acceleration)
	character.move_and_slide() 

# hit stun, knock and bounce mechanic
func knock(normal: Vector2, stun: bool = true, knock_speed: float = speed * 2.5) -> void:
	var knock_dir: Vector2 = normal
	
	if not stun and direction:
		if direction == Vector2i.UP:
			# if jumping on impact just goes up to give more control to the player
			knock_dir = Vector2.UP
		else:
			# just adds direction to the normal
			knock_dir = (normal + Vector2(direction)).normalized()
	
	character.velocity = knock_dir * knock_speed
	
	if stun:
		set_direction(Vector2i(0, 0))
		stop_movement()
	else:
		set_direction(knock_dir.sign())

func jump():
	character.velocity.y = jump_initial_velocity
	jump_acceleration_timer.start()

func set_direction(dir: Vector2i) -> void:
	if can_move:
		last_direction = direction
		direction = dir

func stop_movement(time: float = 0.4):
	can_move = false
	stop_movement_timer.start(time)

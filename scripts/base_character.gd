class_name BaseCharacter extends CharacterBody2D

@export_category("Stats")
@export var hp: int = 10
@export var attack: int = 2

@export_category("Movement")
@export var facing_right: bool = true
@export var speed: float = 5
@export_range(0, 1) var acceleration: float = 0.3

@export_category("Jump")
@export var gravity: float = 50
@export var jump_initial_velocity: float = 12.5
@export var jump_acceleration: float = 1.75

# to work with smaller numbers on inspector
# times scale.x to keep physics consistent when changing character scale
@onready var delta_multiplier: float = 100 * scale.x

# animation
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback =  anim_tree["parameters/playback"]
@onready var sprite: Sprite2D = $Sprite2D

# movement
@onready var jump_timer: Timer = $JumpTimer # time period in wich character is jumping (gaining acceleration)
var jump_inertia: float # keep jump last direction if no x direction is set in set_direction
var direction: Vector2 # normalized vector that tells character movement direction (or intended movement direction)

func _ready() -> void:
	anim_tree.active = true
	
	# movement
	gravity *= delta_multiplier
	speed *= delta_multiplier
	acceleration *= delta_multiplier
	jump_initial_velocity *= -1 * delta_multiplier
	jump_acceleration *= -1 * delta_multiplier * 10 # times 10 because gravity is hard to beat

func _physics_process(delta: float) -> void:
	var last_direction: Vector2 = direction
	set_direction()
	
	var is_jumping: bool = direction.y < 0
	var target_velocity_x: float = direction.x * speed
	
	if is_on_floor():
		jump_inertia = 0
		if is_jumping:
			velocity.y = jump_initial_velocity
			jump_timer.start()

	# jumping
	else:
		velocity.y += gravity * delta
		
		# if jump and hold, goes further
		if jump_timer.time_left:
			if is_jumping:
				velocity.y += jump_acceleration * delta
			else:
				jump_timer.stop()

		# if changes directions mid-air
		if direction.x != last_direction.x:
			# if not going in any direction, keep last direction momentum
			if not direction.x:
				jump_inertia = last_direction.x * 0.5
		elif direction.x:
			jump_inertia = direction.x

		target_velocity_x = speed * jump_inertia

	# lerp function to smoothen movement
	velocity.x = move_toward(velocity.x, target_velocity_x, acceleration)
	move_and_slide()

func _process(_delta: float) -> void:
	update_animation_tree()

# function to be overriden in children
func set_direction() -> void:
	pass

func update_animation_tree():
	anim_tree.set("parameters/air/blend_position", velocity.normalized().y)
	anim_tree.set("parameters/floor/blend_position", direction.x)
	
	check_flip()
	
	var current_node_name: String = playback.get_current_node()
	var next_node_name: String = current_node_name
	
	if is_on_floor():
		# play ground animation if character is landing without moving in x axis
		if not direction.x and current_node_name == "air":
			next_node_name = "ground"
		else:
			next_node_name = "floor"
	else:
		next_node_name = "air"

	if next_node_name != current_node_name:
		playback.travel(next_node_name)

func check_flip() -> void:
	if facing_right:
		if direction.x < 0:
			flip()
	else:
		if direction.x > 0:
			flip()

func flip() -> void:
	facing_right = not facing_right
	scale.x = abs(scale.x) * -1

func hit(_area: Area2D) -> void:
	pass

func take_damage(amount: int):
	hp -= amount

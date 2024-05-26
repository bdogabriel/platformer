class_name AnimationHandlerComponent extends Node

@export var animation_tree: AnimationTree
@export var facing_right: bool = true

var character: BaseCharacter # set by BaseCharacter
var movement_component: MovementComponent # set by BaseCharacter
var current_animated_state_name: String

func _ready():
	animation_tree.active = true

func _physics_process(_delta):
	_update_animation_tree()

func _update_animation_tree():
	# grounded
	if character.is_on_floor():
		set_state("movement", "grounded")
		# change animation speed depending on velocity
		animation_tree.set("parameters/run_time_scale/scale", 0.25 + abs(character.velocity.normalized().x))
		if movement_component.direction.x == 0:
			set_state("grounded","idle")
		else:
			abort_one_shot("land_one_shot") # cancel landing animation if running
			set_state("grounded","run")
	# in_air
	else:
		# preparing landing animation
		animation_tree.set("parameters/idle_time_seek/seek_request", 0.5)
		fire_one_shot("land_one_shot")
		
		set_state("movement", "in_air")
		if character.velocity.y < 0:
			set_state("in_air", "jump")
		else:
			set_state("in_air", "fall")
	
	check_flip()

func check_flip() -> void:
	if facing_right:
		if movement_component.direction.x < 0:
			flip()
	else:
		if movement_component.direction.x > 0:
			flip()

func flip() -> void:
	facing_right = not facing_right
	character.scale.x = abs(character.scale.x) * -1

func fire_one_shot(one_shot: String):
	var path: String = "parameters/" + one_shot + "/request"
	animation_tree.set(path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func abort_one_shot(one_shot: String):
	var path: String = "parameters/" + one_shot + "/request"
	animation_tree.set(path, AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)

func set_state(transition: String, state: String) -> void:
	var path: String = "parameters/" + transition + "/transition_request"
	animation_tree.set(path, state)

func get_current_state(transition: String) -> String:
	var path: String = "parameters/" + transition + "/current_state"
	return animation_tree.get(path)

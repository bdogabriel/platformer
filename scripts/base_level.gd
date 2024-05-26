extends Node2D

@onready var start_position: Marker2D = $StartPosition

func _ready():
	var player: Player = GameManager.player
	if not player.owner:
		add_child(player)
	player.global_position = start_position.global_position

extends Pickup

const LEVEL_BASE_FILE_NAME = "res://scenes/levels/level_"

func _on_picked_up(_player: Player):
	var current_level_file_path: String = get_tree().current_scene.scene_file_path
	var current_level_number = current_level_file_path.to_int()
	var next_level_number: int = current_level_number + 1
	var next_level_file_path: String = LEVEL_BASE_FILE_NAME + str(next_level_number) + ".tscn"
	
	# changing levels
	if ResourceLoader.exists(next_level_file_path):
		var next_level_scene: PackedScene = load(next_level_file_path)
		# remove player from current scene so it does not get freed
		get_tree().current_scene.remove_child(GameManager.player)
		GameManager.player.request_ready()
		get_tree().change_scene_to_packed(next_level_scene)

extends Pickup

func _on_picked_up(_player: Player):
	GameManager.player_coin_count += 1

extends Pickup

func _on_picked_up(player: Player):
	player.coin_count += 1

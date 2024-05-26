extends Pickup

@export var heal_amount: float = 1

func _on_picked_up(player: Player):
	player.health_component.heal(heal_amount)
	player.potion_count += 1

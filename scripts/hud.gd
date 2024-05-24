extends CanvasLayer

@onready var player_health_component: HealthComponent = GameManager.player_health_component
@onready var progress_bar: TextureProgressBar = $HealthBar/TextureProgressBar
@onready var coin_count_label: Label = $ScorePanel/Panel/CoinCountLabel
@onready var potion_count_label: Label = $ScorePanel/Panel/PotionCountLabel

func _ready():
	progress_bar.max_value = player_health_component.max_hp
	progress_bar.value = player_health_component.hp
	coin_count_label.text = str(GameManager.player_coin_count)
	potion_count_label.text = str(GameManager.player_potion_count)

func _process(_delta):
	if is_instance_valid(player_health_component):
		progress_bar.value = player_health_component.hp
	coin_count_label.text = str(GameManager.player_coin_count)
	potion_count_label.text = str(GameManager.player_potion_count)
	

class_name HUD extends CanvasLayer

@onready var progress_bar: TextureProgressBar = $HealthBar/TextureProgressBar
@onready var coin_count_label: Label = $ScorePanel/Panel/CoinCountLabel
@onready var potion_count_label: Label = $ScorePanel/Panel/PotionCountLabel

var player: Player # set by player

func _ready():
	GameManager.hud = self

func _process(_delta):
	if is_instance_valid(player):
		progress_bar.max_value = player.health_component.max_hp
		progress_bar.value = player.health_component.hp
		coin_count_label.text = str(GameManager.player.coin_count)
		potion_count_label.text = str(GameManager.player.potion_count)
	

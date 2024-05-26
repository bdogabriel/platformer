class_name Player extends BaseCharacter

var coin_count: float = 0
var potion_count: float = 0

func _ready():
	super._ready()
	GameManager.player = self
	GameManager.hud.player = self
	GameManager.hud.progress_bar.max_value = health_component.max_hp
	GameManager.hud.progress_bar.value = health_component.hp
	GameManager.hud.coin_count_label.text = str(coin_count)
	GameManager.hud.potion_count_label.text = str(potion_count)

func _physics_process(_delta):
	var direction: Vector2i = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	movement_component.set_direction(direction)

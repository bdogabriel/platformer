class_name HitboxComponent extends Area2D

@export var gravity_center: Marker2D

signal hit

func _ready():
	area_entered.connect(_on_area_entered)
	body_shape_entered.connect(_on_body_shape_entered)

func _on_area_entered(area):
	if area is AttackAreaComponent and area.is_active():
		var damage: float = area.attack_component.deal_damage()
		var normal: Vector2 = area.gravity_center.global_position.direction_to(gravity_center.global_position)
		
		hit.emit(normal, damage)
		
		# attacker on_attack_hit
		if area.has_method("on_attack_hit"):
			area.on_attack_hit(normal)

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int):
	if body is TileMap:
		var layer: int = body.get_layer_for_body_rid(body_rid)
		var collided_tile_coords: Vector2i = body.get_coords_for_body_rid(body_rid)
		var tile_data: TileData = body.get_cell_tile_data(layer, collided_tile_coords)
		var damage: float = tile_data.get_custom_data("damage")
		
		if damage:
			var damage_tile_physics_layer_index: int = 1
			var normal: Vector2 = tile_data.get_constant_linear_velocity(damage_tile_physics_layer_index)
			
			hit.emit(normal, damage)

extends Node2D

@onready var mario=get_tree().current_scene.get_node("Mario")

var Blocks=[Vector2i(66,2),Vector2i(67,2),Vector2i(68,2),Vector2i(67,3),Vector2i(68,3),Vector2i(67,4),Vector2i(68,4),Vector2i(66,5),Vector2i(66,6),Vector2i(66,7),Vector2i(66,8),Vector2i(66,9),]

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.


func _on_correct_path_body_entered(body: Node2D) -> void:
	if body==mario:
		for block in Blocks:
			$ForegroundTile.set_cell(block,1,Vector2i.ZERO)
		var level=load("res://Scenes/level_4_4_3.tscn").instantiate() # Replace with function body.
		level.global_position.x=$End.global_position.x
		self.get_parent().final=level
		self.get_parent().add_child(level)


func _on_wrong_path_body_entered(body: Node2D) -> void:
	if body==mario:
		var level=load("res://Scenes/level_4_4_2.tscn").instantiate()
		level.global_position.x=$End.global_position.x
		self.get_parent().add_child(level)

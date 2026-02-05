extends Node2D

@onready var mario=get_tree().current_scene.get_node("Mario")

func _ready() -> void:
	await get_tree().process_frame

func _on_correct_path_body_entered(body: Node2D) -> void:
	if body==mario:
		var level=load("res://Scenes/level_4_4_2.tscn").instantiate() # Replace with function body.
		level.global_position.x=$End.global_position.x
		self.get_parent().add_child(level)


func _on_wrong_path_body_entered(body: Node2D) -> void:
	if body==mario:
		var level=load("res://Scenes/level_4_4_1.tscn").instantiate()
		level.global_position.x=$End.global_position.x
		self.get_parent().add_child(level)


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.

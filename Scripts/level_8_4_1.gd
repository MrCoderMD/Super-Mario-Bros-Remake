extends Node2D


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var level=load("res://Scenes/level_8_4_1.tscn").instantiate()
	level.global_position.x=$End.global_position.x
	get_tree().current_scene.add_child(level)


func _on_wrong_transition_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		Global.can_transition=true
		Global.transitionx["8-4"]=$WrongTransition.global_position.x# Replace with function body.\
		Global.transition_level["8-4"]=load("res://Scenes/level_8-4.tscn")
		Global.spawn["8-4"]=Vector2i(20,11)


func _on_right_transition_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		Global.can_transition=true
		Global.transitionx["8-4"]=$RightTransition.global_position.x# Replace with function body.\
		Global.transition_level["8-4"]=load("res://Scenes/level_8_4_2.tscn")
		Global.spawn["8-4"]=Vector2i(7,11)

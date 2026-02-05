extends Node2D

var path=[false,false,false]
var addedlevel:PackedScene

func _on_left_correct_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		path[0]=true # Replace with function body.


func _on_mid_correct_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		path[1]=true # Replace with function body.


func _on_right_correct_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		path[2]=true # Replace with function body.


func _on_check_path_body_exited(body: Node2D) -> void:
	if body.name=="Mario":
		if false in path:
			addedlevel=load("res://Scenes/level_7_4_2.tscn")
		else:
			addedlevel=load("res://Scenes/level_7_4_3.tscn")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var level=addedlevel.instantiate()
	level.global_position.x=$End.global_position.x
	get_tree().current_scene.add_child(level)


func _on_left_wrong_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		path[0]=false # Replace with function body.
	


func _on_mid_wrong_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		path[1]=false # Replace with function body.
	


func _on_right_wrong_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		path[2]=false # Replace with function body.
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free() # Replace with function body.

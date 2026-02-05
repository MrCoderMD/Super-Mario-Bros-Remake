extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PauseSound.play() # Replace with function body.



func _on_resume_pressed() -> void:
	get_tree().paused=false
	if get_tree().current_scene.has_node("CameraFollower"):
		get_tree().current_scene.get_node("CameraFollower/Controls")._ready()
	else:
		get_tree().current_scene.get_node("Controls")._ready()
	self.queue_free()


func _on_options_pressed() -> void:
	var options=load("res://Scenes/options.tscn").instantiate()
	options.process_mode=PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(options)


func _on_main_menu_pressed() -> void:
	get_tree().paused=false
	Global.size-=1
	Global.size=clamp(Global.size,0,2)
	Global.reset_status()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

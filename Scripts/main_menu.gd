extends Control

func _ready() -> void:
	z_index=-100


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/stage_transition.tscn") # Replace with function body.


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn") # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.

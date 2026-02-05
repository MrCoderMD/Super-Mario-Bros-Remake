extends Control

func _ready() -> void:
	$MarginContainer/HBoxContainer/Label.text="MARIO\n"+str(Global.score)
	$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Coins.text="x"+str(Global.coins)
	$MarginContainer/HBoxContainer/Label2.text="WORLD\n"+Global.currentlevel
	$AudioStreamPlayer2D.play()

func _on_audio_stream_player_2d_finished() -> void:
	Global.reset_status()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") # Replace with function body.

extends Control

func _ready() -> void:
	$MarginContainer/HBoxContainer/Score.text="MARIO\n"+str(Global.score)
	$VBoxContainer/World.text="WORLD "+Global.currentlevel
	$VBoxContainer/HBoxContainer/Lives.text="x"+str(Global.lives)
	$MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Coins.text="x"+str(Global.coins)
	await get_tree().create_timer(2.0).timeout
	Global.can_transition=true
	Global.is_completed=false
	Global.is_warped=false
	if Global.currentlevel in Global.ug_lvl:
		get_tree().change_scene_to_file("res://Scenes/level_1-2-2.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/level_"+Global.currentlevel+".tscn")

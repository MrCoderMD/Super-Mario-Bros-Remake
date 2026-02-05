extends Area2D

@onready var sfx=Configfile.load_music_settings()


func _on_body_entered(body):
	if body.name=="Mario":
		Global.coins+=1
		if Global.coins==100:
			Global.lives+=1
			Global.coins=0
			var music=AudioStreamPlayer2D.new()
			music.volume_linear=sfx["sfx_volume"]*0.01
			music.stream=load("res://files/sounds/oneup.wav")
			if get_tree().current_scene.has_node("CameraFollower"):
				get_tree().current_scene.get_node("CameraFollower").add_child(music)
			else:
				get_tree().current_scene.add_child(music)
			music.play()
		else:
			body.get_node("CoinSound").play()
		self.queue_free()

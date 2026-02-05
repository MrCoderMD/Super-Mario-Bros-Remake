extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.coins+=1
	if Global.coins==100:
		Global.lives+=1
		Global.coins=0
		var music=AudioStreamPlayer2D.new()
		music.stream=load("res://files/sounds/oneup.wav")
		get_tree().current_scene.get_node("CameraFollower").add_child(music)
		music.play()
	else:
		$AudioStreamPlayer2D.play() # Replace with function body.



func _on_audio_stream_player_2d_finished() -> void:
	self.queue_free() # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible=false # Replace with function body.

extends Area2D

func _on_body_entered(body):
	if body.name=="Mario":
		body.is_underwater=true
		body.get_node("JumpSound").stream=load("res://files/sounds/shot.wav")
		await get_tree().create_timer(0.5).timeout
		get_tree().current_scene.get_node("StaticBody2D").set_collision_layer_value(4,true)
			

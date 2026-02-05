extends Area2D

var is_bridge_gone:=false

func _on_body_entered(body):
	if body.name=="Mario":
		body.velocity.y=0
		get_tree().current_scene.get_node("Bowser").set_physics_process(false)
		if !is_bridge_gone:
			is_bridge_gone=true
			visible=false
			for areas in get_tree().current_scene.get_children():
				if areas is Area2D:
					areas.queue_free()
			await get_tree().current_scene.finish_castle()
			return

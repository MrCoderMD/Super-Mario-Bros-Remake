extends Area2D

var has_powered_up:=false

signal firepowerup

func _on_body_entered(body):
	if body.name=="Mario":
		self.queue_free()
		if Global.size==Global.Size.FIERY:
			Global.lives+=1
			body.pop_up_score("1UP",body.global_position)
			body.add_child(Global.lifeup) # Replace with function body.
			Global.lifeup.play()
			await Global.lifeup.finished
			body.remove_child(Global.lifeup) # Replace with function body.
		elif Global.size==Global.Size.SMOL:
				body.mario_power_up(true)
				self.queue_free()
		else:
			firepowerup.emit()

extends Node2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y-=50*delta


func _on_timer_timeout() -> void:
	self.queue_free() # Replace with function body.

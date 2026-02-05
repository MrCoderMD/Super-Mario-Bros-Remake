extends CharacterBody2D

const JUMP_VELOCITY = -600.0

func _ready() -> void:
	velocity.y= JUMP_VELOCITY

func _physics_process(delta: float) -> void:
	move_and_slide()	
	if is_on_floor():
		var spikey=load("res://Scenes/spikey.tscn").instantiate()
		spikey.global_position=self.global_position
		get_tree().current_scene.add_child(spikey)
		self.queue_free()
	else:
		velocity.y+=Global.GRAVITY*delta

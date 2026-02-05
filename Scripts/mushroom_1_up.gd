extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

var direction:=1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += Global.GRAVITY * delta

	velocity.x+=direction*SPEED*delta
	velocity.x=clamp(velocity.x,-SPEED,SPEED)
	if is_on_wall():
		direction*=-1
		velocity.x=0

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision=get_slide_collision(i)
		var body=collision.get_collider()
		if body.name == "Mario":
			Global.lives+=1
			body.pop_up_score("1UP",body.global_position)
			var music=AudioStreamPlayer2D.new()
			music.stream=load("res://files/sounds/oneup.wav")
			get_tree().current_scene.get_node("CameraFollower").add_child(music)
			music.play()
			self.queue_free()
			await music.finished
			music.queue_free()
			

extends CharacterBody2D

signal powerup

const SPEED = 150.0

var direction:=1
var has_changed_dir:=false

func _process(delta: float) -> void:
	# Add the gravity.
	velocity.x=direction*SPEED
	if not is_on_floor():
		velocity.y += Global.GRAVITY * delta

	if is_on_wall():
		if !has_changed_dir:
			direction*=-1
			has_changed_dir=true
	
	if not is_on_wall():
		has_changed_dir=false

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision=get_slide_collision(i)
		var body=collision.get_collider()
		if body.name == "Mario":
			if !body.has_powered_up:
				body.has_powered_up=true
				powerup.emit()
				self.queue_free()

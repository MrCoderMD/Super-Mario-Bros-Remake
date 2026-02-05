extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	move_and_slide()
	if is_on_wall():
		velocity.x*=-1
	if !is_on_floor():
		velocity.y+=Global.GRAVITY*delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		body.shrink_or_die() # Replace with function body.

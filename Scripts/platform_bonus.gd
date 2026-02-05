extends CharacterBody2D

@export var target:int
var SPEED = 0


func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity.y=0
	velocity.x=SPEED
	if global_position.x>=target:
		velocity.x=0
		await get_tree().create_timer(0.5).timeout
		self.queue_free()
	

func _on_area_2d_body_entered(body) -> void:
	if body.name=="Mario":
		SPEED=150 # Replace with function body.

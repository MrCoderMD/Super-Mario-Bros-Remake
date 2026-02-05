extends Area2D

var velocity:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity=Vector2(160,0) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x+=velocity.x*delta
	global_position.y+=velocity.y*delta+0.5*Global.GRAVITY*pow(delta,2)
	velocity.y+=Global.GRAVITY*delta
	if global_position.y>=400:
		velocity.y=-426.67


func _on_body_entered(body):
	if body.name=="Mario":
		body.star_invincible()
		self.queue_free() # Replace with function body.

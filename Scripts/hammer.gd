extends Area2D

var velocity:Vector2
var dir:int

func _ready() -> void:
	$AnimatedSprite2D.flip_h=(dir<0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position+=velocity*delta
	velocity.y+=Global.GRAVITY*delta
	#print(global_position)
	if global_position.y>480:
		self.queue_free()

func _on_body_entered(body) -> void:
	if body.name=="Mario":
		if !body.is_invincible:
			body.shrink_or_die() # Replace with function body.
		else:
			velocity.y=-100
